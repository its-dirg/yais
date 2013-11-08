# -*- coding: utf-8 -*-
import argparse
import json
import os

__author__ = 'haho0032'


#Run as create_idp_conf.py << create_idp_conf.json

class TemplateCreator:

    def addReplace(self, conf, id, value):
        conf["config"]["replace"].append({"id": id,"value": value})
        return conf

    def manipulateLine(self, write, line, conf):
        for field in conf["config"]["section"]:
            start = "<" + field["id"] +">"
            end = "</" + field["id"] +">"
            testline = line.strip()
            if field["show"] == "False":
                if testline == start:
                    return (False, None)
                if testline == end:
                    return (True, None)
            else:
                if (testline == start) or (testline == end):
                    return (True, None)
        for field in conf["config"]["replace"]:
            if write:
                replace = "<" + field["id"] +">"
                filedvalue = field["value"]
                if filedvalue is None:
                    filedvalue = ""
                line=line.replace(replace, filedvalue)
        if not write:
            return (False, None)
        return (True, line)

    def write_configuration(self, conf, path, template_file):
        returnData = {}

        filename = "conf"
        try:
            filename = conf["filename"]
        except:
            pass

        if "forceOverWrite" not in conf or conf["forceOverWrite"]=="False":
            nameNotOK = True
            counter = 0
            tmp_name = filename
            while nameNotOK:
                counter += 1
                try:
                    fp=open(tmp_name)
                    fp.close()
                    tmp_name = filename + "_" + counter
                except IOError:
                    nameNotOK = False
            name = tmp_name
        returnData["filename"] = filename + ".py"

        ins = open( template_file, "r" )
        fp = open(path + "/" + returnData["filename"], "w")
        write = True
        for line in ins:
            write, line = self.manipulateLine(write, line, conf)
            if write and line is not None:
                fp.write(line)

        ins.close()
        fp.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(dest="config")
    args = parser.parse_args()

    json_data=open(args.config)
    conf = json.load(json_data)
    json_data.close()

    TemplateCreator().write_configuration(conf,
                                    os.path.dirname(os.path.abspath(__file__))+"/../../test/idp/pysaml2/example/idp2",
                                    "../../templates/idp/", "idp_conf.template")

    #TemplateCreator().write_configuration(conf,
    #                                os.path.dirname(os.path.abspath(__file__))+"/../../test/idp/pysaml2/example/sp",
    #                                "../../templates/sp/", "sp_conf.template")
