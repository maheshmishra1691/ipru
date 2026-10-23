@echo off
cd /d "%~dp0"
py -3 -m pip install --no-index --find-links="%~dp0wheels" -r "%~dp0requirements.txt"
if errorlevel 1 python -m pip install --no-index --find-links="%~dp0wheels" -r "%~dp0requirements.txt"
if errorlevel 1 (
  echo Install failed. Python 3.10 or newer with pip is required.
  pause
  exit /b 1
)
python -c "import selenium; print(selenium.__version__)"
pause
