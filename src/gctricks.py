import gc, atexit

class optimizeGC:
  """https://instagram-engineering.com/dismissing-python-garbage-collection-at-instagram-4dca40b29172"""

  def __enter__(self):
    # gc.set_threshold(0)
    gc.disable()

  def __exit__(self, etype, value, traceback):
    # atexit.register(os._exit, 0)
    gc.enable()
