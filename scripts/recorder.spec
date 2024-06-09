# -*- mode: python ; coding: utf-8 -*-
from PyInstaller.utils.hooks import collect_data_files


datas=[ ( 'recorder.qml', '.' )]
block_cipher = None


a = Analysis(
    ['recorder.py'],
    pathex=["venv/lib/python3.8/site-packages/"],
    binaries=[("/Users/iroro/anaconda3/lib/libmkl_intel_thread.1.dylib", ".")],
    datas=datas,
    hiddenimports=["sounddevice"],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)


exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='recorder',
    debug=True,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

# app = BUNDLE(exe,
#          name='myscript.app',
#          icon=None,
#          bundle_identifier=None)
         
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='recorder',
)
