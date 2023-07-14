# ToDo menu description
This is a ToDo manager addon (currently only supports Godot 4.x).

> This addon is a work-in-progress, so there may be massive changes made without warning, and it might be very buggy. Please report all bugs so I can fix them.


### ToDo
The addon adds a ToDo tab to the bottom panel, which looks like this when clicked:

![Example of the ToDo menu in use. You can have as many items in this list as you need.](/todo.png)

This allows you to add notes for things you want to add or change. When you finish doing something, you can press the arrow button to move the item to the Changelog (which automatically turns some words like "add" and "fix" to "added" and "fixed" respectively).


### Changelog
The Changelog can be used to remind you what you have changed and acomplished on a day. It might be motivational to you, reminding you what you have acomplished.

In the future I plan on adding a feature to create a changelog text that can be copy-pasted into your website or a GitHub project page.

![Screenshot of the Changelog menu. This can be used to remind you what you did on that particular day.](/changelog.png)

Every category/day uses a different horizontal box, keeping it more organized. You can rename the title shown by clicking the pencil. The title defaults to the day the category represents. If you rename the title, you can hover over it to show both the title and the date (if editing the category to make it blank, it will automatically turn to the default value. If you want to avoid this for some reason, you can use a whitespace character as the title instead).

The arrows can be used to rearrange the categories to better suit you. All changes persist, and are loaded in when you re-open the editor.
