import json
from datetime import datetime, timedelta
from collections import defaultdict

completed_sessions = defaultdict(int)

with open('pom.json', 'r') as file:
    data = json.load(file)

for session in data:
    if session['completed']:
        date = datetime.fromisoformat(session['start_time']).date()
        completed_sessions[date] += 1

start_date = min(completed_sessions.keys(), default=datetime.now().date())
end_date = max(completed_sessions.keys(), default=datetime.now().date())

with open('completed.txt', 'w') as file:
    for single_date in (start_date + timedelta(n) for n in range((end_date - start_date).days + 1)):
        count = completed_sessions.get(single_date, 0)
        file.write(f'{single_date}: {count}\n')
