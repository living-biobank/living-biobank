$('#labs').replaceWith("<%= j render 'labs/table', lab_groups: @lab_groups %>")
initializeSelectpickers()
