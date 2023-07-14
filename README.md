# python-setup
a simple .bat file that will help setup a python virtual environment to help automate the process



# Usage: 
1. Clone a python project into a folder i.e "proj1" 
    * **NOTE**: this step is not needed if you only want to create a python virtual environment
2. Launch command line interface (cmd) inside the project folder 
3. Run the "python_setup.bat" as follows: 

```
python_setup.bat --y python3.9.13 venv
```


Key areguments described below:

| Arguement                     | Required (y/n)  | Description                  | Example        | Default        |
| ------------------------------|:---------------:| ---------------------------- | -------------- |:--------------:|
| `--[include_dependencies]`    |        n        | flag to run requirements.txt | --y or --n     | --y            |
| `python_version`              |        y        | desired python version       | python3.9.13   | python3.9.13   |
| `venv_name`                   |        n        | name of virtual environment  | venv           | venv           |