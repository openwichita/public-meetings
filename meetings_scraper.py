"""
Prototype for scraping Wichita City meeting schedules

Council and Subdision PDF scrapers are defined below as classes. Meeting is the base class that can be inherted from and overriden as needed. The scraping code uses class methods, while the instances (Meeting objects) are created from parsed meeting dates.

Todo
----
* Add a web scraper class
* Break into files / make into package ???
* Assertion and/or Unit testing
* See whether this approach works with other scraping needs (web scraping)


Implementing a scraper
--------------------
class ScraperNameMeeting(Meeting):
    pdf_url = "http://url_to_schedule.pdf"
    
    def __init__(self, year, month, day, # any other params):
        self.type = "some_type"
        self.summary = "Meeting label/title"
        self.description = "what the meeting is about in general"
        self.location = "address"
        self.date = datetime(year, month, day, hour, minute)
        self.agenda = "url to online agenda"
        self.email = "contact person(s)"
        # any other attributes for this kind of meeting
        
    @classmethod
    def parse_meetings(cls, pdf, date_lines):
        # code for querying/parsing pdf 
        # Passed a PDFQuery object
"""


# Libraries needed by the code below
from icalendar import Calendar, Event
from datetime import datetime
import urllib.request as request
from pdfquery import PDFQuery
import json
import re


# Base Scaper Class
class Meeting:
    """Base Class for Wichita city meetings. Includes scraping code and instance definition"""
    
    ###    Class properties   ###
    year = datetime.now().year # Current year
    pdf_url = None # Needs to be defined by inheriting classes
    
    # Sometimes first letter is missing (part of a different layout element)
    months = ['anuary', 'ebruary', 'arch', 'pril', 'ay', 'une', 'uly', 'ugust', 'eptember', 'ctober', 'ovember', 'ecember']
    
    
    @classmethod
    def fetch_pdf(cls):
        """Get the online pdf and load it as PDFQuery object
        
            Parameters
            ----------
            cls: class passed in by Python

            Returns
            -------
            pdf: PDFQuery object
        """
        
        url = cls.pdf_url.format(cls.year) # put the year into the url
        output = "{0} => {1}".format(cls.year, url)
        print(output)
        
        with request.urlopen(url) as response:
            filename = "files/{0}_{1}.pdf".format(cls.__name__, cls.year)
            contents = response.read()
            
            f = open(filename, 'wb')
            f.write(contents)
            f.close()
            
            print("Meeting PDF written to file: {0}".format(filename))
            
            pdf = PDFQuery(filename)
            pdf.load()
            return pdf
        
        
    @classmethod
    def get_date_lines(cls, pdf):
        """Match the pdf text lines containing dates
        
            Parameters
            ----------
            cls: class passed in by Python
            pdf: PDFQuery object created from meetings pdf

            Returns
            -------
            date_lines: list of line, month (int), day (int)
        """
        
        date_lines = []
        day_pattern = "\d{1,2}"  # Match on Month 1-31
        
        for month_text in cls.months:
            # Get any lines that match month text
            lines_h = pdf.pq('LTTextLineHorizontal:contains("{0}")'.format(month_text))
            lines_box = pdf.pq('LTTextBoxHorizontal:contains("{0}")'.format(month_text))
            month_lines = lines_h + lines_box
            
            # Iterate over lines containing month
            for line in month_lines:
                match_day = re.search(day_pattern, line.text)
                
                # If it has a day, then it's a date line
                if match_day:
                    month = cls.months.index(month_text) + 1 # offset by 1
                    day = int(match_day.group()) # Day is in the second group 
                    
                    # Add tuple of line, month, day
                    date_line = (line, month, day) 
                    date_lines.append(date_line)
        
        return date_lines
    
    
    @classmethod     
    # Override this one for PDF specific parsing
    def parse_meetings(cls, pdf, date_lines):
        """Parse the pdf text lines for meeting events
        
            Parameters
            ----------
            cls: class passed in by Python
            pdf: PDFQuery object created from meetings pdf
            date_lines: tuple of pdf line, month & day (ints)

            Returns
            -------
            meetings: list of class specific meeting instances
        """
        
        meetings = []
        
        for line, month, day in date_lines:
            # PDFs may require additional checking here before creating meeting
            meeting = cls(cls.year, month, day)
            meetings.append(meeting)
        
        print("{0} meetings generated".format(len(meetings)))
        return meetings
    
    @classmethod
    def get_meetings(cls, year=None):
        """Parse the pdf text lines for meeting events. Called by get_meetings function.
        
            Parameters
            ---------
            year: 4 digit year
                  Defaults to None, which means use current year
            
            Returns
            -------
            meetings: list of meetings generated from online pdf
        """
        
        # Override the classe's year if it's been passed in
        if year:
            cls.year = year
        
        pdf = cls.fetch_pdf()
        lines = cls.get_date_lines(pdf)
        meetings = cls.parse_meetings(pdf, lines)
        return meetings
    
    ###   Decorators    ###
    # Decorator for to_ics, to_json, to_csv methods
    # Saves data to file in proper format if save parameter is passed as True
    def savefile(func):
        def wrapper(self, save=False):
            if save:
                ext = func.__name__.replace("to_", "")
                year = self.date.year
                month = self.date.month
                day = self.date.day
                data = func(self)
                filename = "files/{0}_meeting_{1}_{2}_{3}.{4}".format(self.type, month, day, year, ext)

                flag = 'w'
                if ext == 'ics': # ics is byte string
                    flag = 'wb'

                file = open(filename, flag)
                file.write(data)
                file.close()

                print("Meeting saved to", filename)
                return filename
            else:
                return func(self)
        return wrapper
    
    
    ###   Instance Methods    ###
    def __init__(self, year, month, day):
        self.summary = "Generic Meeting"
        self.description = "Some sort of description"
        self.location = "1845 Fairmount St, Wichita, KS 67260"
        self.date = datetime(year, month, day, hour=14, minute=15)
        self.agenda = "http://google.com"
        self.email = "marcus@gmail.com"
     
    # Friendly String format
    def __repr__(self):
        data_format = "%a %b %d %I:%M %p"
        date_str = self.date.strftime(data_format)
        return "{0}: {1}".format(date_str, self.summary)
    
    # Iterator for properties: to_json, to_csv use it
    def __iter__(self):
        for prop in self.__dict__:
            yield prop, self.__dict__[prop]
    
    def to_cal(self):
        """Convert meeting to ical object
            
            Returns
            -------
            cal: ical object with meeting event added
        """

        cal = Calendar()
        event = Event()
        dt = self.date

        event.add("dtstart", dt)
        event.add("dtstamp", dt)
        event.add("dtend", datetime(dt.year, dt.month, dt.day, dt.hour + 2, dt.minute)) # Add two hours
        event.add("summary", self.summary)
        event.add("description", self.description)
        event.add("location", self.location)
        event.add("url", self.agenda)

        cal.add_component(event)
        return cal
         
    @savefile
    def to_ics(self):
        """Convert meeting to ics byte string"""
        
        cal = self.to_cal()
        return cal.to_ical()
    
    @savefile
    def to_json(self):
        """Convert meeting to json format"""
        
        props = {}
        for key, value in self:
            props[key] = value
        
        props["date"] = props["date"].isoformat() # Have to convert to string format
        return json.dumps(props)
    
    @savefile
    def to_csv(self):
        """Convert to csv format"""
        
        csv_str = ""
        for key, value in self:
            if type(value) is str: 
                # Wrap string values in quotes
                csv_str += '"{0}",'.format(value)
            else:
                csv_str += '{0},'.format(value)
        
        return csv_str[0:-1] # remove trailing comma
    
    # For display in Jupyter Notebook
    # Just for the hell of it
    def to_html(self):
        """Convert to html format"""
        from IPython.display import HTML
        
        html_str = '<div style="padding: 10px; width: 60%; transform: skewX(174deg); box-shadow: 10px 10px 5px #888888; background: lavenderblush url(https://developer.fedoraproject.org/static/logo/elixir.png) no-repeat 105% bottom; background-size:42%; margin-left: 20px;">'
        
        for key, value in self:
            html_str += "<p><strong>{0}</strong>: ".format(key)
            
            if type(value) is str: 
                # Wrap string values in quotes
                if "@" in value:
                    html_str += '<span style="color:darkred">{0}</span>'.format(value)
                elif "http" in value:
                    html_str += '<span style="color:darkblue">{0}</span>'.format(value)
                elif key == "location":
                     html_str += '<span style="font-weight:bold; color:darkgray">{0}</span>'.format(value)
                else:      
                    html_str += '<span style="color:darkgreen">{0}</span>'.format(value)
            else:
                html_str += '<span style="color:darkorange">{0}</span>'.format(value)
            
            html_str += "</p>"
        html_str += "</div>"
            
        return HTML(html_str)


# This was done first, so a bit messy, overrides Meeting class too much
# Needs to be refactored
class CouncilMeeting(Meeting):
    """Class for Council Meetings"""
    
    pdf_url = "http://www.wichita.gov/Government/Council/CityCouncilDocument/{0}%20CITY%20COUNCIL%20MEETING%20SCHEDULE.pdf"
    
    # Months dictionary for matching PDF text. January and Frebruary sometimes missing first letter in City Council Meetings pdf.
    months = {'anuary': 1, 'January': 1, 'ebruary': 2, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6, 'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12}
      
    @classmethod
    def get_text_lines(cls, pdf):
        """Extract the lines of text in the pdf
        
            Paramters
            ---------
            pdf: PDFQuery object

            Returns
            -------
            lines: dicitonary of text lines from pdf keyed by first y position
        """

        headers = pdf.pq('LTTextBoxHorizontal')
        labels = pdf.pq('LTTextLineHorizontal') + headers
        
        # 2018 Header for January meetings should be skipped
        next_year_text = "{0} City Council Schedule".format(cls.year + 1)
        next_year_header = pdf.pq('LTTextLineHorizontal:contains("{0}")'.format(next_year_text)) # Should be only one on page
        next_year_y0 = round(float(next_year_header[0].get("y0")))
        # print(label_2018_header, label_2018_y0)
        
        lines = {}

        for label in labels:
            text = label.text
            y0 = round(float(label.get("y0")))
            x0 = label.get("x0")
            
            # If the label is below 2018 header, exclude it
            if y0 < next_year_y0:
                # print("Skip", text, y0)
                continue
            elif text and text != " ":
                if not y0 in lines:
                    lines[y0] = []

                # print(y0, label)
                lines[y0].append(label)

        print("{0} lines of text extracted".format(len(lines)))
        return lines
    
    @classmethod
    def parse_date(cls, text):
        """Extract the Month and Day in integer format

            Paramaters
            ----------
            text: string which potentially has textual month and numeric day

            Returns
            -------
            tuple or None: integer (month, day) or None if no match
        """

        # Iterate through keys (month names) in months dictionary
        for month_key in cls.months.keys():
            if month_key in text:
                match = re.search("\d+", text) # Match on the numeric day

                if match:
                    day = int(match.group())  # It will be the first matach group
                    month = cls.months[month_key] # Get the integer version for the month
                    return month, day
            
        # Won't get here if there is a match above
        return None
    
    @classmethod
    def parse_meetings(cls, lines):
        """Parse the pdf text lines for meeting events

            Parameters
            ---------
            lines: dictionary of text lines extracted from pdf

            Returns
            -------
            meetings: list of generated meeting dictionaries
        """
        meetings = []
        
        for y0, line in lines.items():
            line = sorted(line, key=lambda label: float(label.get("x0")))

            if len(line) == 1:
                label = line[0]
                text = label.text.strip()
            else:
                for index in range(0, len(line), 2):
                    text1 = line[index].text.strip()
                    text2 = line[index + 1].text.strip()
                    result = cls.parse_date(text1)
                    
                    # print("***", text1, text2, result, "***")

                    if result:
                        month, day = result[0], result[1]
                        meeting_text = text2

                        if meeting_text == "Regular Meeting":
                            # print("Regular", month, day)
                            
                            summary = "Regular Council Meeting"
                            description = "Provide policy direction for Wichita"
                            
                            meeting = CouncilMeeting(summary, description, cls.year, month, day)
                            meetings.append(meeting)
                        elif meeting_text == "Consent/Workshop":
                            # print("Workshop", month, day)
                            
                            summary = "Consent/Workshop Council Meeting"
                            description = "Review and discuss important issues, staff projects and future Council meeting agenda items"
                            meeting = CouncilMeeting(summary, description, cls.year, month, day, minute=30)
                            meetings.append(meeting)
                        else:
                            continue
                    else:
                        print("***", text1, text2, "***")

        print("{0} meetings generated".format(len(meetings)))
        return meetings
    
    @classmethod
    def get_meetings(cls, year=None):
        """Parse the pdf text lines for meeting events
            
            Returns
            -------
            meetings: Meetings list of meetings generated from online pdf
        """
        
        if year:
            cls.year = year
        
        pdf = cls.fetch_pdf()
        lines = cls.get_text_lines(pdf)
        meetings = cls.parse_meetings(lines)
        return meetings
    
    def __init__(self, summary, description, year, month, day, hour=9, minute=0):
        self.type = "council"
        self.summary = summary
        self.description = description
        self.location = "455 N Main, 1st Floor Board Room Wichita, KS 67202"
        self.date = datetime(year, month, day, hour, minute)
        
        agenda_base_url = "http://www.wichita.gov/Government/Council/Agendas/{0}-{1}-{2}".format(month, day, year)
        # Agenda is posted 4 days before meeting
        self.agenda = "{0}%20City%20Council%20Agenda%20Packet.pdf".format(agenda_base_url)
        # Final agenda is posted 1 day before
        self.agenda_final = "{0}%20Final%20City%20Council%20Agenda%20Packet.pdf".format(agenda_base_url)
        self.email = "JCJohnson@wichita.gov;EGlock@wichita.gov;MLovely@wichita.gov;JHensley@wichita.gov;DLCityCouncilMembers@wichita.gov"


class SubdivsionMeeting(Meeting):
    # There is a revised pdf url for 2016 revised meetings (has REVISED in the name)
    # http://www.wichita.gov/Government/Departments/Planning/PlanningDocument/2016%20REVISED%20Subdivision%20Calendar.pdf
    
    # Note: could use exception handling to load revised pdf if initial has been replaced
    
    # Also a vacation calendar
    # http://www.wichita.gov/Government/Departments/Planning/PlanningDocument/2016%20Vacation%20Calendar.pdf
   
    pdf_url = "http://www.wichita.gov/Government/Departments/Planning/PlanningDocument/{0}%20Subdivision%20Calendar.pdf"
    
    def __init__(self, year, month, day):
        self.type = "subdivision"
        self.summary = "Subdivision and Utility Advisory Meeting"
        self.description = "City utility design planning and review" # Needs better descripiton
        self.location = "The Ronald Reagan Building, 271 W. 3rd St N, Suite 203, Wichita KS 67201"
        self.date = datetime(year, month, day, hour=10, minute=0)
        
        base_url = "http://www.wichita.gov/Government/Departments/Planning/AgendasMinutes/{0}-{1}-{2}".format(month, day, year)
        self.agenda = "{0}%20Subdivision%20Agenda%20packet.pdf".format(base_url)
        self.plat_drawings = "{0}%20Subdivision%20Agenda%20-%20Plat%20drawings.pdf".format(base_url)
        self.email = "nstrahl@wichita.gov" #??

        
    @classmethod 
    # Not overriden optimally, could be rewritten
    def parse_meetings(cls, pdf, date_lines):
        """Extract the lines of text in the pdf, parse for date, and create meeting object
        
            Paramters
            ---------
            pdf: PDFQuery object
            date_lines: tuple of line, month & day (int) 
                        Note: not used but should be

            Returns
            -------
            meetings: list of meeting objects
        """
        
        months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 
          'November', 'December']
        
        # Any dates below this line on this side of the page are meeting dates
        header = pdf.pq('LTTextLineHorizontal:contains("MEETING DATES")')
        header_line = header[0] # Should only be one
        header_line_x0 = header_line.get('x0')
        
        # Detect the day and year
        day_year_pattern = "(\d{1,2}), (\d+)"
        
        meetings = []
        
        # Iterate through months and get meeting text lines for each month
        for month_text in months:
            meeting_lines = pdf.pq('LTTextLineHorizontal:contains("{0}")'.format(month_text))
            
            for line in meeting_lines:
                x0 = line.get("x0")
                x1 = line.get("x1")
                result = re.search(day_year_pattern, line.text)

                day = int(result.groups()[0])
                year = int(result.groups()[1])

                if year != 2017:
                    # print("\t* Wrong year!", line.text)
                    pass
                elif x0 >= header_line_x0:
                    # Legitimate meeting
                    # print("Added Meeting: ", month[:3], day, year, line.get("x0"))
                    month = months.index(month_text) + 1 # Get month number value from class months dictionary
                    meeting = SubdivsionMeeting(cls.year, month, day)
                    meetings.append(meeting)
                else:
                    # print("\tSkip", line.text, line.get("x0"))
                    pass
        
        print("{0} meetings parsed".format(len(meetings)))
        return meetings
    
    
# Enhanced meeting list
class MeetingList(list):
    """Inherits from list, custom additions defined below"""
    
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
        if type(value) is str:
            for meeting in self:
                time_str = "{0}/{1}".format(meeting.date.month, meeting.date.day)
                if value in time_str:
                    return meeting
            
            # If hasn't matched above, then filter on Month textual name (capitalized)
            meetings = MeetingList(filter(lambda meeting: value == meeting.date.strftime("%B"), self))
            if len(meetings) == 0:
                return None
            else:
                return meetings 
        else:
            return super().__getitem__(value) 
        
    
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
            year = self[0].__class__.year
            filename = "files/meetings_{0}.json".format(year)

            f = open(filename, 'w')
            f.write(json_str)
            f.close()
            
            print("Meetings saved to", filename)
        else:
            return json_str
        

# Add additionally defined scrapers to list
scrapers = [CouncilMeeting, SubdivsionMeeting]


# This function calls the scrapers defined below
def get_meetings(year=None):
        """Calls pdf scrapers for extracting meeting dates
        
            Parameters
            ----------
            year: four digit number of desired year
                  Defaults to None (scraper classes defautl to current year)
            
            Returns
            -------
            meetings: Combined and sorted list of meetings generated from online pdfs
        """
        
        meetings = [] # List of meetings to add to
        
        for scraper in scrapers:
            scraper_meetings = scraper.get_meetings(year)
            meetings = meetings + scraper_meetings
        
        meetings = sorted(meetings, key=lambda meeting: meeting.date) # Sort by date ascending
        return MeetingList(meetings) # Return converted to Meetings list