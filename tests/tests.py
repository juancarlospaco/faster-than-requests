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
    self.assertIsNone(faster_than_requests.debugs())

  def test_get2ndjson_list(self):
    self.assertIsNone(faster_than_requests.get2ndjson(["http://httpbin.org/json", "http://httpbin.org/json"], "output.ndjson"))

  def test_downloads_list(self):
    self.assertIsNone(faster_than_requests.download2([("http://httpbin.org/image/jpeg", "foo.jpg"), ("http://httpbin.org/image/svg",  "bar.svg")]))

  def test_downloads(self):
    self.assertIsNone(faster_than_requests.download("http://httpbin.org/image/jpeg", "foo.jpeg"))

  def test_tuples2json(self):
    self.assertEqual(faster_than_requests.tuples2json([("key0", "value0"), ("key1", "value1")]), '{\n  "key0": "value0",\n  "key1": "value1"\n}')

  def test_gets(self):
    self.assertIsInstance(faster_than_requests.get("http://httpbin.org/get"), dict)

  def test_posts(self):
    self.assertIsInstance(faster_than_requests.post("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""), dict)

  def test_put(self):
    self.assertIsInstance(faster_than_requests.put("http://httpbin.org/put", """{"foo": "bar", "baz": true}"""), dict)

  def test_deletes(self):
    self.assertIsInstance(faster_than_requests.delete("http://httpbin.org/delete"), dict)

  def test_patch(self):
    self.assertIsInstance(faster_than_requests.patch("http://httpbin.org/patch", """{"foo": "bar", "baz": true}"""), dict)

  def test_get2str(self):
    self.assertTrue(dict(json.loads(faster_than_requests.get2str("http://httpbin.org/get"))))

  def test_get2dict(self):
    self.assertIsInstance(faster_than_requests.get2dict("http://httpbin.org/get"), list)

  def test_get2json(self):
    self.assertTrue(dict(json.loads(faster_than_requests.get2json("http://httpbin.org/get"))))

  def test_get2json_pretty(self):
    self.assertTrue(dict(json.loads(faster_than_requests.get2json("http://httpbin.org/get"))))

  def test_post2str(self):
    self.assertTrue(dict(json.loads(faster_than_requests.post2str("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))))

  def test_post2dict(self):
    self.assertIsInstance(faster_than_requests.post2dict("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""), list)

  def test_post2json(self):
    self.assertTrue(dict(json.loads(faster_than_requests.post2json("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))))

  def test_post2json_pretty(self):
    self.assertTrue(dict(json.loads(faster_than_requests.post2json("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))))

  def test_get2str_list(self):
    self.assertIsInstance(faster_than_requests.get2str2(["http://httpbin.org/json", "http://httpbin.org/xml"]), list)

  def test_multipartdata2str(self):
    self.assertEqual(faster_than_requests.multipartdata2str([("key", "value")]), '------------------------------ 0 ------------------------------\nname="key"\n\nvalue\n')

  def test_urlparse(self):
    self.assertEqual(faster_than_requests.urlparse("https://www.google.com/search?q=faster-than-requests"), ['https', '', '', 'www.google.com', '', '/search', 'q=faster-than-requests', '', "False"])

  def test_urlencode(self):
    self.assertEqual(faster_than_requests.urlencode("http://nim-lang.org"), r'http%3A%2F%2Fnim-lang.org')

  def test_urldecode(self):
    self.assertEqual(faster_than_requests.urldecode(r'http%3A%2F%2Fnim-lang.org'), "http://nim-lang.org")

  def test_encodequery(self):
    self.assertEqual(faster_than_requests.encodequery([("key", "value")]), "key=value")

  def test_encodexml(self):
    self.assertEqual(faster_than_requests.encodexml("<h1>Hello World</h1>"), "&lt;h1&gt;Hello World&lt;/h1&gt;")

  def test_minifyhtml(self):
    self.assertEqual(faster_than_requests.minifyhtml("\n  <h1>Hello</h1>  \n   <h1>World</h1>  \n"), "<h1>Hello</h1> <h1>World</h1>")

  # def test_datauri(self):
  #   self.assertEqual(faster_than_requests.datauri("Nim", "text/plain"), "data:text/plain;charset=utf-8;base64,Tmlt")


if __name__.__contains__("__main__"):
  print(__doc__)
  unittest.main()
