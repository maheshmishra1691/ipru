# Selenium packages for offline install

Selenium 4.51.0 and the Python packages it needs. The files in `wheels` are the official releases from PyPI. They run on Windows, Mac, and Linux with Python 3.10 or newer.

## On the office laptop

Download this repository as a ZIP, unzip it, then in that folder run:

```bat
py -3 -m pip install --no-index --find-links=wheels -r requirements.txt
```

If `py` is not recognized:

```bat
python -m pip install --no-index --find-links=wheels -r requirements.txt
```

Or double-click `install-selenium.bat`.

Check the install:

```bat
python -c "import selenium; print(selenium.__version__)"
```

That should print `4.51.0`.
