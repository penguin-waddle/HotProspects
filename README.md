# HotProspects: Conference Networking Simplified

## Overview
<table>
  <tr>
    <td>
      <img src="https://github.com/penguin-waddle/HotProspects/assets/123434744/206dad98-7581-47be-90f9-3a2c4a07dba5" alt="Hot Prospects App Demo" width="300" />
    </td>
    <td>
      HotProspects is an iOS app designed for networking at conferences. It simplifies the process of keeping track of people you meet. The app allows users to generate their own QR code containing their details and scan others' codes to add them as contacts for future follow-ups.
    </td>
  </tr>
</table>

## Key Features
- **QR Code Generation**: Users can create a personal QR code carrying their contact information.
- **QR Code Scanning**: Easily scan other attendees' QR codes to gather their details.
- **Contact Management**: Classify contacts into 'contacted' and 'uncontacted' for efficient follow-up.
- **Notification Reminders**: Set reminders to contact people you've met.
- **Data Persistence**: Save scanned contacts for future reference.

## Technical Implementation
- **SwiftUI**: App built using SwiftUI, offering a modern and responsive interface.
- **Custom Data Sharing**: Utilizes environment objects for data sharing across views.
- **QR Code Integration**: Implements QR code generation and scanning using `CIFilterBuiltins`.
- **User Notifications**: Uses `UserNotifications` for scheduling follow-up reminders.
- **Sorting and Filtering**: Provides options to sort and filter contacts based on different criteria.

## Code Structure
- **ContentView**: Root view managing tab views and environment objects.
- **ImageSaver**: Handles saving QR codes to the user's photo album.
- **MeView**: Allows users to input their details and generates a QR code.
- **Prospect**: Model class representing an individual prospect with Codable conformance for data persistence.
- **Prospects**: Observable object class managing a list of `Prospect` objects.
- **ProspectsView**: Displays contacts based on filters (contacted/uncontacted) with QR code scanning functionality.

## Challenges Overcome
- Creating a seamless interface for QR code generation and scanning.
- Managing a large number of contacts efficiently with sorting and filtering.
- Implementing custom notifications for each contact.
- Ensuring data security and privacy while sharing contact information.

## Future Enhancements
- Integration with calendar apps for scheduling meetings.
- Automated follow-up emails or messages.
- Advanced sorting options based on meeting location or time.
- Cloud synchronization for access across multiple devices.

---

*HotProspects was developed as part of the "100 Days of SwiftUI" course. It demonstrates the use of SwiftUI for building complex interfaces, integrating Core Image for QR code handling, and managing local data storage.*

---

[Back to Main Repository](https://github.com/penguin-waddle/100-Days-of-SwiftUI)
