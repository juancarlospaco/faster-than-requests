import faster_than_requests as requests
import time
import datetime
import urllib.request

print ("Faster")
start = datetime.datetime.now()
requests.get2str('http://localhost/sureflap-master/LockOutsite.php')
end = datetime.datetime.now()
time_taken = end - start
print('Time: ', time_taken)

start = datetime.datetime.now()
requests.get2str('http://localhost/sureflap-master/UnLock.php')
end = datetime.datetime.now()
time_taken = end - start
print('Time: ', time_taken)

print ("UrlLib")
start = datetime.datetime.now()
webUrl  = urllib.request.urlopen('http://localhost/sureflap-master/LockOutsite.php')
end = datetime.datetime.now()
time_taken = end - start
print('Time: ', time_taken)

start = datetime.datetime.now()
webUrl  = urllib.request.urlopen('http://localhost/sureflap-master/UnLock.php')
end = datetime.datetime.now()
time_taken = end - start
print('Time: ', time_taken)
