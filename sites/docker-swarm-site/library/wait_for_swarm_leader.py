#!/usr/bin/python

from ansible.module_utils.basic import *
import requests
import signal
import time

class Timeout():
    #
    # Timeout class using ALARM signal
    # This class only works on linux
    #
    class Timeout(Exception):
        pass

    def __init__(self, sec):
        self.sec = sec

    def __enter__(self):
        signal.signal(signal.SIGALRM, self.raise_timeout)
        signal.alarm(self.sec)

    def __exit__(self, *args):
        signal.alarm(0)    # disable alarm

    def raise_timeout(self, *args):
        raise Timeout.Timeout()

def main():
    fields = {
          "consul_server": {"required": True, "type": "str"},
          "consul_port":  {"default": "8500", "required": False, "type": "str"},
          "docker_api_version": {"default": "v1.26", "required": False, "type": "str"},
          "timeout": {"default": 180, "type": "int"}
    }

    module = AnsibleModule(argument_spec=fields)

    role = ""
    consulServer = module.params['consul_server']
    consulServerPort = module.params['consul_port']
    dockerApiVersion = module.params['docker_api_version']
    timeout = module.params['timeout']

    try:
      with Timeout(timeout):
        while role != "primary":
          try:
            # get the swarm leader ip:port from the consul server
            r = requests.get('http://'+ consulServer +':'+ consulServerPort +'/v1/kv/docker/swarm/leader?raw')
            managerIp = str(r.content)

            # get the swarm manager host info
            r = requests.get('http://' + managerIp + '/'+ dockerApiVersion +'/info')
            response = r.json()

            # find the Role status
            for key,value in response["SystemStatus"]:
              if key == "Role":
                role = value
                returnValues = {"managerIp": managerIp,"role": value}
                break

          except Timeout.Timeout:
            # re-raise the Timeout exception
            raise
          except:
            # skip all exceptions except Timeout
            pass
    except Timeout.Timeout:
      module.fail_json( rc=1, msg="Timeout occured after " + str(timeout) + " seconds" )


    module.exit_json(changed=False, meta=returnValues)


if __name__ == '__main__':
    main()
