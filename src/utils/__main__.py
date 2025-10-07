if __name__ == '__main__':
    import utils
    clsid=utils.CLSIDFromProgID("word.application")
    print(utils.ProgIDFromCLSID(clsid))
    # import os
    # print(os.environ["PYTHONPATH"])
