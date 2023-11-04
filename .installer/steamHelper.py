import typing
import io
import json
import os
from typing import Any
import psutil
import subprocess

ENCODING = "utf-8"

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
    with open(path, "wb") as f:
        writeVdf(f, None, shortcuts)

def getSteamFolder() -> str:
    if os.name == "nt":
        return "C:\\Program Files (x86)\\Steam\\"
    elif os.name == "posix":
        raise Exception()
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
    
    def getShortcutsPath(self) -> str:
        return os.path.join(self.steamFolder, "userdata", self.uid, "config", "shortcuts.vdf")

class Shortcut:
    def __init__(self, dict: typing.Dict) -> None:
        self.dict = dict
    
    def AppName(self) -> str:
        return self.dict["AppName"]
    
    def SetAppName(self, val: str):
        self.dict["AppName"] = val

    def Exe(self) -> str:
        return self.dict["Exe"]
    
    def SetExe(self, val: str):
        self.dict["Exe"] = val
    
    def StartDir(self) -> str:
        return self.dict["StartDir"]
    
    def SetStartDir(self, val: str):
        self.dict["StartDir"] = val

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
        raise Exception()
    
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

    subprocess.Popen(f"\"{exe}\"", creationflags=subprocess.DETACHED_PROCESS)

if __name__ == "__main__":
    users = getUsers()
    for user in users:
        dict = parseShortcuts(user.getShortcutsPath())
        enc = json.encoder.JSONEncoder()
        enc.indent = 4
        js = enc.encode(dict)
        print(js)
        #addShortcutToSteam(user.getShortcutsPath(), "Little Jnr", "C:\\Users\\milky\\Documents\\GitHub\\LittleJNR\\.Build\\Windows\\Little Jnr.exe", "C:\\Users\\milky\\Documents\\GitHub\\LittleJNR\\.Build\\Windows\\", "C:\\Users\\milky\\Documents\\GitHub\\LittleJNR\\Sprites\\Icon\\Web512.png")
        #restartSteam()
        