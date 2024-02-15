def parse_course_info(course_info):
    # Split the input string into course blocks, ignoring the first split if it's empty
    course_blocks = [block for block in course_info.split('expand') if block.strip() != '']
    courses = []

    for block in course_blocks:
        # Split each block by the known labels to extract information
        parts = block.split('Days & Time\tBld. / Room')
        course_name = parts[0].strip()
        details = parts[1].strip().split('\t')
        
        # Assuming the format for days/times and building/room is consistent and separated by a tab
        days_and_times = details[0].strip()
        building_room = details[1].split('/')
        
        building = building_room[0].strip()
        room = building_room[1].strip()

        # Extract days and times, assuming a space separates them
        days, times = days_and_times.split(' ', 1)
        
        course_dict = {
            "name": course_name,
            "days": days,
            "times": times,
            "building": building,
            "room": room
        }
        
        courses.append(course_dict)
    
    import json
    return json.dumps(courses, indent=2)

course_info2 = '''expand	
Capital Markets & Financial Management
Days & Time	Bld. / Room
M-W---- 1:00PM-2:20PM	Knight Executive Education Center / TBD
expand	
Organization Behavior Within the Firm
Days & Time	Bld. / Room
M-W---- 2:30PM-3:50PM	Bauer Hall / 230
expand	
Amplifying Cyberdiversity: Real Humans in Virtual Spaces
Days & Time	Bld. / Room
-T----- 5:30PM-7:30PM	Cupples II / 200
expand	
Object-Oriented Software Development Laboratory
Days & Time	Bld. / Room
M-W---- 10:00AM-11:20AM	Eads / 016
expand	
Visual Principles for the Screen
Days & Time	Bld. / Room
-T-R--- 8:30AM-11:20AM	Kemper (Mildred Lane Kemper Art Museum) / 40
'''
# Parse and print the structured course information
structured_course_info = parse_course_info(course_info2)
print(structured_course_info)
