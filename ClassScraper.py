def parse_course_info(course_info):
    # Split the input string into course blocks, ignoring the first split if it's empty
    course_blocks = [block for block in course_info.split('\n\t') if block.strip() != '']
    courses = []

    print(course_blocks)

    for block in course_blocks:
        # Split each block by the known labels to extract information
        parts = block.split('Days & Time\tBld. / Room')
        course_name = parts[0].strip()
        details = parts[1].strip().split('\t')

        print(details)

        days_and_times = details[0].split(' ')
        building_room = details[1]

        print(days_and_times)

        days, times = days_and_times[0], days_and_times[1]

        if (days_and_times[1] == "TBA"):
            days, times = days_and_times.split(' ', 1)
        
        course_dict = {
            "name": course_name,
            "days": days,
            "times": times,
            "building_room": building_room
        }

        courses.append(course_dict)
        
        
        # # Assuming the format for days/times and building/room is consistent and separated by a tab
        # days_and_times = details[0].strip()
        # building_room = details[1].split('/')
        
        # building = building_room[0].strip()
        # room = building_room[1].strip()

        # # Extract days and times, assuming a space separates them
        # days, times = days_and_times.split(' ', 1)
        
        # course_dict = {
        #     "name": course_name,
        #     "days": days,
        #     "times": times,
        #     "building": building,
        #     "room": room
        # }
        
        # courses.append(course_dict)
    
    import json
    return json.dumps(courses, indent=2)

course_info2 = '''
Web Development
Days & Time	Bld. / Room
-T-R--- 2:30PM-3:50PM	Urbauer / 222
	Introduction to Parallel and Concurrent Programming
Days & Time	Bld. / Room
-T-R--- 11:30AM-12:50PM	Eads / 016
	Analysis of Algorithms
Days & Time	Bld. / Room
M------ 2:30PM-3:50PM	Brauer Hall / 012
	Analysis of Algorithms
Days & Time	Bld. / Room
--W---- 2:30PM-3:50PM	Simon Hall / 017
	Independent Study
Days & Time	Bld. / Room
TBA N/A	TBA
	Software Engineering Workshop
Days & Time	Bld. / Room
-T----- 5:30PM-8:30PM	Urbauer / 218
	Video Game Programming
Days & Time	Bld. / Room
M-W---- 4:00PM-5:20PM	Eads / 016
	Intermediate French 1
Days & Time	Bld. / Room
M-W-F-- 10:00AM-10:50AM	Cupples I / 215


'''
# Parse and print the structured course information
structured_course_info = parse_course_info(course_info2)
print(structured_course_info)
