import typing
import io
import json
import os
import psutil

ENCODING = "utf-8"
steampath = None

def readVdf(r: io.BufferedReader) -> typing.Tuple[str, object]:
    type = r.read(1)
    if type == b'\x00':   # NUL
        key = str(readTo(r), ENCODING)
        value = {}
        while True:
            listKey, listVal = readVdf(r)
            if listKey == None:
                break
            value[listKey] = listVal
        if isList(value):
            value = list(value.values())
    elif type == b'\x01': # SOH
        key = str(readTo(r), ENCODING)
        value = str(readTo(r), ENCODING)
    elif type == b'\x02': # STX
        key = str(readTo(r), ENCODING)
        value = int.from_bytes(r.read(4), byteorder="little", signed=True)
    elif type == b'\b':
        return None, None
    else:
        raise Exception("Parsing error")
    
    return key, value

def writeVdf(w: io.BufferedWriter, key: str, val):
    if isinstance(val, str):
        if key != None:
            w.write(b'\x01')
            w.write(bytes(key, ENCODING))
            w.write(b'\x00')
        w.write(bytes(val, ENCODING))
        w.write(b'\x00')
    elif isinstance(val, int):
        if key != None:
            w.write(b'\x02')
            w.write(bytes(key, ENCODING))
            w.write(b'\x00')
        i = val & 0xFFFFFFFF
        w.write(i.to_bytes(4, byteorder="little", signed=True))
    elif isinstance(val, typing.List):
        if key != None:
            w.write(b'\x00')
            w.write(bytes(key, ENCODING))
            w.write(b'\x00')
        for i, item in enumerate(val):
           writeVdf(w, str(i), item)
        w.write(b'\b')
    elif isinstance(val, typing.Dict):
        if key != None:
            w.write(b'\x00')
            w.write(bytes(key, ENCODING))
            w.write(b'\x00')
        for k in list(val.keys()):
            writeVdf(w, k, val[k])
        w.write(b'\b')
    else:
        raise Exception("Unparsable type")

def readTo(r: io.BufferedReader, endCharacter: int = b'\x00') -> bytes:
    ret = b""
    while True:
        b = r.read(1)
        if b == endCharacter:
            return ret
        ret += b

def isList(dict: typing.Dict) -> bool:
    keys = list(dict.keys())
    for i in range(0, len(keys)):
        if keys[i] != str(i):
            return False
    return True

def parseShortcuts(path: str) -> typing.Dict:
    with open(path, "rb") as f:
        key, dict = readVdf(f)
        return {key: dict}     

def writeShortcuts(path: str, shortcuts: dict):
    writer = io.BytesIO()
    writeVdf(writer, None, shortcuts)
    with open(path, "wb") as f:
        f.write(writer.getbuffer())
        pass

def getSteamFolder() -> str:
    global steampath

    if os.name == "nt":
        if steampath != None:
            return steampath
        import winreg
        reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        try:
            key = winreg.OpenKey(reg, "SOFTWARE\\Valve\\Steam")
            steampath, _ = winreg.QueryValueEx(key, "InstallPath")
            key.Close()
        except EnvironmentError:
            try:
                key = winreg.OpenKey(reg, "SOFTWARE\\Wow6432Node\\Valve\\Steam")
                steampath, _ = winreg.QueryValueEx(key, "InstallPath")
                key.Close()
            except EnvironmentError as ex:
                print(ex)
                steampath = None
        reg.Close()
        return steampath
    elif os.name == "posix":
        if steampath == None:
            path = os.path.expanduser("~/.steam/steam")
            if os.path.exists(path):
                steampath = path
        return steampath
    else:
        raise Exception()

def addShortcutToSteam(vdfPath:str, appName: str, exe: str, startDir: str, icon: str = "", launchOptions: str = ""):
    appid = hash(f"{appName}")
    shortcut = {
            "appid": appid, 
            "AppName": appName, 
            "Exe": f"\"{exe}\"", 
            "StartDir": f"\"{startDir}\"",
            "icon": f"\"{icon}\"",
            "LaunchOptions": f"\"{launchOptions}\"",
            }

    shortcuts = parseShortcuts(vdfPath)
    for sc in shortcuts["shortcuts"]:
        if "AppName" in sc and sc["AppName"] == appName:
            shortcuts["shortcuts"].remove(sc)
    shortcuts["shortcuts"].append(shortcut)
    writeShortcuts(vdfPath, shortcuts)

class User:
    def __init__(self, steamFolder:str, uid: str) -> None:
        self.steamFolder = steamFolder
        self.uid = uid
        self.PersonaName = f"NoName ({uid})"

        path = os.path.join(self.steamFolder, "userdata", self.uid, "config", "localconfig.vdf")
        with open(path, "r", errors="replace", encoding="utf-8") as f:
            while True:
                line = f.readline()
                if line == None or line == '':
                    break
                elements = [s for s in line.split("\t") if s.strip() != '']
                if len(elements) >= 2 and elements[0].strip('"') == "PersonaName":
                    self.PersonaName = elements[1].strip('"\r\n\t')
    
    def getShortcutsPath(self) -> str:
        return os.path.join(self.steamFolder, "userdata", self.uid, "config", "shortcuts.vdf")

def getUsers() -> typing.List[User]:
    list = []
    steamfolder = getSteamFolder()
    userdata = os.path.join(steamfolder, "userdata")
    folders = os.listdir(userdata)
    for folder in folders:
        scs = os.path.join(userdata, folder, "config", "shortcuts.vdf")
        if os.path.exists(scs):
            list.append(User(steamfolder, folder))
    return list

def restartSteam():
    if os.name == "nt":
        PNAME = "steam.exe"
    else:
        PNAME = "steam"
    
    process = None
    for p in psutil.process_iter(attrs=["pid", "name", "cmdline"]):
        if p.info["name"] == PNAME:
            process = p
            break
    
    exe = None

    if process != None:
        exe = process.exe()
        os.system(f"\"{exe}\" -exitsteam")
        process.wait()
    
    if exe == None:
        exe = os.path.join(getSteamFolder(), PNAME)

    if os.name == "nt":
        os.system(f"start \"{exe}\"")
    elif os.name == "posix":
        os.system(f"nohup \"{exe}\" &")
    else:
        raise Exception()

if __name__ == "__main__":
    if getSteamFolder() == None:
        print("Steam not installed")
        exit(-1)

    users = getUsers()
    for user in users:
        print("User:", user.PersonaName)
        dict = parseShortcuts(user.getShortcutsPath())
        enc = json.encoder.JSONEncoder()
        enc.indent = 4
        js = enc.encode(dict)
        print(js)
        #addShortcutToSteam(user.getShortcutsPath(), "Little Jnr", "C:\\Users\\milky\\Documents\\GitHub\\LittleJNR\\.Build\\Windows\\Little Jnr.exe", "C:\\Users\\milky\\Documents\\GitHub\\LittleJNR\\.Build\\Windows\\", "C:\\Users\\milky\\Documents\\GitHub\\LittleJNR\\Sprites\\Icon\\Web512.png")
        #restartSteam()
        