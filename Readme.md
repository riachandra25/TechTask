## LiveStyled Tech Test code

PROBLEM DEFINITION
Write a iPhone app in Swift that presents one view controller containing a table view that shows a list of events. The cells of the list should display information about an event.
Note, this endpoint is paginated, and returns only 10 results at a time. To display the full list, you will either need to implement pagination by fetching the desired page using the page query parameter, or increase the limit on the response length using the limit query parameter. We'll leave it up to you to decide which of these we'd prefer 

SOLUTION APPROACH
1. Followed MVVM design pattern to design the base architecture
2. Added autolayout and storyboard to dynamically design the UI
3. Designed the data service layer integrating network handler and storage handler
4. Dynamically parsing JSON with JSONDecoder
5. Custom component to display loading indicator
6. Used SDWebImage open source library for image download and caching (advantage of this library mentioned below)
7. UITableview prefetching for incremental download with pagination
8. Store and retreive favourite event status
9. Integrated unit test case for view model

## SDWebImage Library (Reason for use)

1. To download and cache image custom image downloader is necessary
2. Simple to integrate and use
3. Asynchronous image downloading and caching.
4. URLSession-based networking. Basic image processors and filters supplied.
5. Multiple-layer cache for both memory and disk.
6. Cancelable downloading and processing tasks to improve performance.
7. Independent components. Use the downloader or caching system separately as you need.
8. Prefetching images and showing them from cache later when necessary.
9. Extensions for UIImageView, NSImage and UIButton to directly set an image from a URL.

As the test needs to be completed in limited time and for image downloading this open source library is already available and support multiple feature, so I have used this. 

If given some more time, I would integrate more unit tests and UI tests in the app.




