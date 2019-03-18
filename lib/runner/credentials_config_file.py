import os


def read_from_config_file(key):
    properties = read_properties_file()
    return properties[key]


def read_from_config_file_with_default(key, default_value):
    properties = read_properties_file()
    return properties.get(key, default_value)


# ~~~~ Helpers


def read_properties_file():
    current_dir = os.path.dirname(__file__)
    properties = load_properties(os.path.join(current_dir, "..", "..", "config", "credentials.config"))
    return properties


def load_properties(filepath, sep='=', comment_char='#'):
    """
    Read the file passed as parameter as a properties file.
    """
    props = {}
    try:
        with open(filepath, "rt") as f:
            for line in f:
                l = line.strip()
                if l and not l.startswith(comment_char):
                    key_value = l.split(sep)
                    key = key_value[0].strip()
                    value = sep.join(key_value[1:]).strip().strip('"')
                    value = value.replace("\=", "=")
                    if value in ['true', 'false']:
                        value = value == 'true'
                    props[key] = value
        return props
    except IOError as e:
        print('ERROR: You need to download the credentials.config file before you can run this.')
        exit(1)
