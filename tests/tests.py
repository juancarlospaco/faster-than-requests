#!/usr/bin/env python3
# -*- coding: utf-8 -*-


"""Faster Than Requests."""


import unittest
import json

from random import randint

try:
    import faster_than_requests
except:
    print("Tests require faster_than_requests installed and working.")


# Random order for tests runs. (Original is: -1 if x<y, 0 if x==y, 1 if x>y).
unittest.TestLoader.sortTestMethodsUsing = lambda _, x, y: randint(-1, 1)


class TestName(unittest.TestCase):

    """Faster Than Requests."""

    maxDiff, __slots__ = None, ()

    def test_debugConfig(self):
        self.assertIsNone(faster_than_requests.debugConfig())

    def test_get2ndjson_list(self):
        self.assertIsNone(faster_than_requests.get2ndjson_list(["http://httpbin.org/json", "http://httpbin.org/json"], "output.ndjson"))

    def test_downloads_list(self):
        self.assertIsNone(faster_than_requests.downloads_list([("http://httpbin.org/image/jpeg", "foo.jpg"), ("http://httpbin.org/image/svg",  "bar.svg")]))

    def test_downloads(self):
        self.assertIsNone(faster_than_requests.downloads("http://httpbin.org/image/jpeg", "foo.jpeg"))

    def test_tuples2json(self):
        self.assertEqual(faster_than_requests.tuples2json([("key0", "value0"), ("key1", "value1")]), '{"key0":"value0","key1":"value1"}')

    def test_gets(self):
        self.assertIsInstance(faster_than_requests.gets("http://httpbin.org/get"), dict)

    def test_posts(self):
        self.assertIsInstance(faster_than_requests.posts("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""), dict)

    def test_put(self):
        self.assertIsInstance(faster_than_requests.put("http://httpbin.org/put", """{"foo": "bar", "baz": true}"""), dict)

    def test_deletes(self):
        self.assertIsInstance(faster_than_requests.deletes("http://httpbin.org/delete"), dict)

    def test_patch(self):
        self.assertIsInstance(faster_than_requests.patch("http://httpbin.org/patch", """{"foo": "bar", "baz": true}"""), dict)

    def test_get2str(self):
        self.assertTrue(dict(json.loads(faster_than_requests.get2str("http://httpbin.org/get"))))

    def test_get2dict(self):
        self.assertIsInstance(faster_than_requests.get2dict("http://httpbin.org/get"), list)

    def test_get2json(self):
        self.assertTrue(dict(json.loads(faster_than_requests.get2json("http://httpbin.org/get"))))

    def test_get2json_pretty(self):
        self.assertTrue(dict(json.loads(faster_than_requests.get2json_pretty("http://httpbin.org/get"))))

    def test_post2str(self):
        self.assertTrue(dict(json.loads(faster_than_requests.post2str("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))))

    def test_post2dict(self):
        self.assertIsInstance(faster_than_requests.post2dict("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""), list)

    def test_post2json(self):
        self.assertTrue(dict(json.loads(faster_than_requests.post2json("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))))

    def test_post2json_pretty(self):
        self.assertTrue(dict(json.loads(faster_than_requests.post2json_pretty("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))))

    def test_requests(self):
        self.assertIsInstance(faster_than_requests.requests("http://httpbin.org/get", "get", "", [("key", "value")]), dict)

    def test_requests2(self):
        self.assertIsInstance(
            faster_than_requests.requests2("http://httpbin.org/get", "get", "", [("key", "value")], userAgent="FasterThanRequests", timeout=9000, maxRedirects=9), dict)

    def test_get2str_list(self):
        self.assertIsInstance(faster_than_requests.get2str_list(["http://httpbin.org/json", "http://httpbin.org/xml"]), list)

    def test_tuples2json_pretty(self):
        self.assertEqual(faster_than_requests.tuples2json_pretty([("key0", "value0"), ("key1", "value1")]),
        '''{
  "key0": "value0",
  "key1": "value1"
}''')


if __name__.__contains__("__main__"):
    print(__doc__)
    unittest.main()
