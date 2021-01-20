import gc, faster_than_requests  #, atexit

class optimizeGC:
  """https://instagram-engineering.com/dismissing-python-garbage-collection-at-instagram-4dca40b29172"""

  def __enter__(self):
    # gc.set_threshold(0)
    gc.disable()
    faster_than_requests.init_client()

  def __exit__(self, etype, value, traceback):
    # atexit.register(os._exit, 0)
    faster_than_requests.close_client()
    gc.enable()
