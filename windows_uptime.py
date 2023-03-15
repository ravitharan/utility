import subprocess
from datetime import datetime

#CMD         = 'net statistics workstation'
#DATE_MARK   = 'Statistics since '
#DATE_FORMAT = '%d/%m/%Y %H:%M:%S'

CMD         = 'systeminfo'
DATE_MARK   = 'System Boot Time:'
DATE_FORMAT = '%d/%m/%Y, %H:%M:%S'

output = subprocess.run(CMD.split(), capture_output=True)

stdout = output.stdout.decode("utf-8") 
for line in stdout.split('\n'):
    if DATE_MARK in line:
        bootup_time = line.replace(DATE_MARK, '').strip()
        bootup = datetime.strptime(bootup_time, DATE_FORMAT)
        current = datetime.now()
        delta = current - bootup
        s = int(delta.total_seconds())
        h = s // 3600
        s -= h * 3600
        m = s // 60
        s -= m * 60
        print(f'{h:2d} hour : {m:2d} min : {s:2d} sec')
        break


