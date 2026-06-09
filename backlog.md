### Dashboard
- Statistic data view
    - total accounts grouped by status (available, limit-hit, etc.)
    - Upcoming available accounts (1 week or so)
    - Recent limit-hit accounts

### Account List Features
[Done] Search by email and name 
[Done] Filter by Account Status 
- OrderBy last used date 

[Done] **Notes: ListTile swipe actions (startToEnd: available, endToStart: limit-hit)** 

### Account Create/Update Features
[Done] Last used date (read-only and update when account status changed)
[Done] Next available date
[Done] Account Delete button with AlertDialog

### General
[Done] Account model update 
[Done] - account type (cursor, Gemini, etc.)

### Settings
- Dark Mode

### Simple "Good-to-Have" Features
- **Account Usage History**: Keep a simple log of when an account was marked as "Limit Hit".
- **Email Copy to Clipboard**: Add a button to quickly copy the account email in the details page.
- **Account Categorization**: Add simple tags like "Work", "Personal", or "Shared".
- **Bulk Status Update**: Option to mark multiple accounts as "Available" at once.
- **Last Sync Indicator**: Show how long ago the account status was last updated (e.g., "Updated 2 hours ago").
- **Empty State Improvements**: Add a "plus" button or illustration when the account list is empty.
- **Account Search History**: Save recent search queries for quick access.
- **Export to CSV**: Simple button to export account list to a CSV file.
