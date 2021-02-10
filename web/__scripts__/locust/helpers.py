import os


class Host:
    @property
    def gateway(self):
        out = os.popen("ip route | awk '/default/ { print $3 }'")
        return out.read()
