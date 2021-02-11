import os
import threading
import logging


logger = logging.getLogger()


class Host:
    @property
    def gateway(self):
        out = os.popen("ip route | awk '/default/ { print $3 }'")
        return out.read()


class Settings:
    _LOCK = threading.Lock()
    _INSTANCE = None

    def __init__(self):
        if not self._LOCK.locked():
            raise RuntimeError('use thread-safe get_instance()')
        self._settings = dict()
        self._lock = threading.Lock()
        self.state = Settings.State()

    @classmethod
    def get_instance(cls):
        cls._LOCK.acquire()
        if cls._INSTANCE is None:
            cls._INSTANCE = cls()
        cls._LOCK.release()
        return cls._INSTANCE

    class State:
        def __init__(self):
            self._container = dict()
            self._lock = threading.Lock()

        def set(self, k, v) -> None:
            self._lock.acquire()
            self._container[k] = v
            self._lock.release()

        def get(self, k):
            self._lock.acquire()
            v = self._container.get(k)
            self._lock.release()
            return v

        def keys(self) -> list:
            self._lock.acquire()
            keys = list(self._container.keys())
            self._lock.release()
            return keys
