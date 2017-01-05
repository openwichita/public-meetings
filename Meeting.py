from IPython.display import HTML, display
from datetime import datetime
import pymysql.cursors
import icalendar
import calendar
import types
import json


# Define Meeting object
class Meeting:
    year = 2017
    
    # initialize object
    def __init__(self, month, day, fields):
        self.date = datetime(self.__class__.year, month, day, fields["hour"], fields["minute"])
        
        del fields["hour"]
        del fields["minute"]
        
        # Add all the fields as attributes for this object
        for key, value in fields.items():
            self.__dict__[key] = value 
          
    # Friendly String representation
    def __repr__(self):
        data_format = "%a %b %d %I:%M %p"
        date_str = self.date.strftime(data_format)
        return "{0}: {1}".format(date_str, self.title)
    
    # Iterator for properties: to_json, to_csv use it
    def __iter__(self):
        for prop in self.__dict__:
            yield prop, self.__dict__[prop]
            
    def to_json(self):
        """Convert meeting to json format"""
        
        props = {}
        for key, value in self:
            #if key == 'id':
                #continue  # skip id
            props[key] = value
           
        date = props["date"]
        
        if props["agenda"]: # interpolate yer, month, day
            day = date.day
            if day < 10:
                day = "0{0}".format(date.day)
                
            month = date.month
            if month < 10:
                month = "0{0}".format(date.month)
            
            props["agenda"] = props["agenda"].format(month, day, date.year)
        
        props["date"] = date.isoformat() # Have to convert to string format
        return json.dumps(props)
    
    def to_ics(self):
        """Convert meeting to ics format
            
            Returns
            -------
            byte string representation of ical object 
        """

        cal = icalendar.Calendar()
        event = icalendar.Event()
        dt = self.date
        
        # Convert duration from minutes to hours and minutes, and add to start time
        hour = self.duration // 60
        minute = self.duration - (hour * 60)
        hour += dt.hour
        minute += dt.minute
        
        event.add("dtstart", dt)
        event.add("dtstamp", dt)
        event.add("dtend", datetime(dt.year, dt.month, dt.day, hour, minute))
        event.add("summary", self.title)
        event.add("description", self.description)
        event.add("location", self.location)
        event.add("url", self.agenda)

        cal.add_component(event)
        return cal.to_ics()
            
            
# Enhanced list with fancy hash matching
class MeetingList(list):
    """Inherits from list, custom additions defined below"""
    
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", 
              "December"]
    
    # Called with use of in: value in variable
    def __contains__(self, value):        
        if type(value) is str:
            for meeting in self:
                time_str = "{0}/{1}".format(meeting.date.month, meeting.date.day)
                if value in time_str:
                    return True
                elif value in meeting.summary:
                    return True
        else:
            return super().__contains__(value)
     
    
    # Called with square bracket acesss: variable[value]
    def __getitem__(self, value):
        """
        Override square bracket method from list
        
        params
        ------
        value: value inside square brackets, can be any type
        
        returns
        -------
        Filterd list or single item matching value (based on filter definition) or error is thrown, if type isn't handled
        """
        vtype = type(value)
        
        # Depending on the type of value passed in, filter accordingly
        # This is long and ugly, but it's just to demonstrate possible convenience of Python metaprogromming via magic methods
        if vtype is int:
            # Day Filter
            meetings = list(filter(lambda meeting: meeting.date.timetuple().tm_yday == value, self))
            
            if len(meetings) == 1:
                return meetings[0]
            else:
                return MeetingList(meetings)
        elif vtype is tuple:
            if type(value[0]) is str:
                meetings = MeetingList(filter(lambda meeting: value[0] == meeting.date.strftime("%B") and
                                        value[1] == meeting.date.strftime("%a"), self))
                return meetings
            else:
                print(vtype, value)
                return super().__getitem__(value) 
        elif vtype is slice:
            start, stop = value.start, value.stop
            step = value.step
            if step is None:
                step = 1
            
            # Days or months
            daterange = list(range(start, stop, step))
            
            if type(start) is int:
                meetings = list(filter(lambda meeting: meeting.date.timetuple().tm_yday in daterange, self))
            else:
                 meetings = list(filter(lambda meeting: meeting.date.strftime("%b") in daterange, self))
            return MeetingList(meetings)
        elif vtype is types.FunctionType:
            meetings = list(filter(value, self))
            return MeetingList(meetings)
        elif vtype is str:
            for meeting in self:
                time_str = "{0}/{1}".format(meeting.date.month, meeting.date.day)
                if value in time_str:
                    return meeting
            
            # If hasn't matched above, then filter on Month textual name (capitalized)
            meetings = MeetingList(filter(lambda meeting: value == meeting.date.strftime("%B"), self))
            if len(meetings) == 0:
                return None
            else:
                # define color styles for html month calendar
                html = """
                    <style>
                        .red { color: #990000; font-weight: bold; }
                    </style>
                """
                
                html += '<p><span class="red">Red: Meeting days</span></p>'
                
                cal = calendar.HTMLCalendar(calendar.SUNDAY)
                month = self.__class__.months.index(value) + 1 # convert to ordinal
                html += cal.formatmonth(2017, month)
                
                for meeting in meetings:
                    color = "red"
                    html = html.replace(">{0}</td>".format(meeting.date.day),
                                                           '><span class="{0}">{1}</span></td>'.format(color, meeting.date.day))
                display(HTML(html))
                return meetings 
        else:
            # any values not specified above, pass to parent to handle (list)
            print(vtype, value)
            return super().__getitem__(value) 
    
    
    @property
    def types(self):
        mtypes = set()
        for meeting in self:
            mtypes.add(meeting.type)
        return sorted(mtypes)
    
    
    def to_json(self, save=False):
        "Convert all meetings to json format"
        
        # Needs to be wrapped in array notation, separated by commas
        json_str = "["
        for meeting in self:
            json_str += meeting.to_json() + ","
            
        # Remove trailing comma and complete with closing array bracket
        json_str = json_str[0:-1] + "]"
        
        if save:
            # Get the year used from first item's class (it's a class variable)
            year = Meeting.year
            filename = "files/meetings_{0}.json".format(year)

            f = open(filename, 'w')
            f.write(json_str)
            f.close()
            
            print("Meetings saved to", filename)
        else:
            return json_str


###  Database  ###
def db_connect():
    conn = pymysql.connect(host='localhost',
                             port=8889,
                             user='root',
                             password='root',
                             db='meetings',
                             charset='utf8',
                             cursorclass=pymysql.cursors.DictCursor)
    cur = conn.cursor()
    return conn, cur


def select_meetings():
    conn, cur = db_connect()
    
    # Get all The types
    cur.execute("SELECT * FROM type;")
    meeting_types = cur.fetchall()

    # Get all the dates
    cur.execute("SELECT * FROM date;")
    meeting_dates = cur.fetchall()
    cur.close()
    conn.close()
    
    return meeting_types, meeting_dates


def get_meetings():
    meeting_types, meeting_dates = select_meetings()
    
    # convert meeting_types to dictionary
    mtypes = {}
    for meeting_type in meeting_types:
        mid = meeting_type["id"]
        mtypes[mid] = meeting_type
        
    meetings = MeetingList()

    # Create all meetings based on dates and types
    for meeting_date in meeting_dates:
        mid = meeting_date["tid"]
        month = meeting_date["month"]
        day = meeting_date["day"]
        fields = mtypes[mid].copy()
        fields["id"] = meeting_date["id"]

        meeting = Meeting(month, day, fields)
        meetings.append(meeting)

    meetings.sort(key=lambda meeting: meeting.date)
    print("{0} meetings listed in {1}".format(len(meetings), Meeting.year))
    return meetings


def first_month_day(day, weekday):
    """day: year, day, month date object
       weekday: integer day of week (0-6)
       return: first weekday (Sun, Mon, Tue, etc) day of month
    """
    from datetime import timedelta
    
    days_ahead = weekday - day.weekday()
    if days_ahead <= 0: # Target day already happened this week
        days_ahead += 7
    return day + timedelta(days_ahead)


def get_meeting_dates(year, weekday, period=7, offset=0, skip_last=False):
    """year: int year
       weekday: date of first weekday for month
       return: list of meeting dates for the year
    """
    from datetime import date
    meeting_dates = []
    
    for month in range(1, 13):
        day = date(year, month, 1)
        first_day = first_month_day(day, weekday)
        _, month_days = calendar.monthrange(2017, month)
        count = 0
        
        for n in range(first_day.day, month_days, period):
            count += 1
            if skip_last:
                if n + period > month_days:
                    continue
            
            n = n + offset # For example, second Tuesday is +7
            
            meeting_dates.append([month, n])
            #print("{0}/{1}".format(month, n), "#{0}".format(count))
        
    return meeting_dates


def insert_meeting_dates(mid, month, day, year=2017):
    add_event = ("INSERT INTO date (type, year, month, day) VALUES (%s, %s, %s, %s)")
    data = (mid, year, month, day)
    
    conn, cur = db_connect()
    cur.execute(add_event, data)
    conn.commit()
    cur.close()
    conn.close()
    print(cur.lastrowid, (mid, year, month, day))
    
    
def insert_meeting_type(fields):
    add_meeting = ("""INSERT INTO type (type, subtype, title, description, location, hour, minute, duration, email, agenda) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""")
    
    conn, cur = db_connect()
    data = (fields["type"], fields["subtype"], fields["title"], fields["description"], fields["location"], fields["hour"],
           fields["minute"], fields["duration"], fields["email"], fields["agenda"])
    cur.execute(add_meeting, data)
    conn.commit()
    cur.close()
    conn.close()
    return cur.lastrowid