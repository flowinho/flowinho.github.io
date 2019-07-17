

Some sites i've created are created utilizing Jekyll and UIKit and use markdown to write the posts. However, images are rendered as default HTML img-tags. UIKit provides this functionality but i prefer sticking to plain markdown. This script replace default img-tags with UIKit lightboxes after the page loaded.

To achieve this, i needed to utilize some basic functionalities of javascript and the webbrowsers DOM, namely:

- `.getElementsByClassName`
- `getElementsByTagName`
- `getAttribute`
- `innerHTML`

Here is the script, with inline explanations:

```javascript
function replaceImgTagWithUIKitLightbox() {
    // Limit the operation only to elements inside minima's post-content div to prevent site-logos being turned
    // into lightboxes.
    var postContent = document.getElementsByClassName('post-content')
    for (var i=0; i < postContent.length; i++){

        // Search for all elements that are embedded using the default <img> tag.
        let images = postContent[i].getElementsByTagName('img')

        for (var j=0; j < images.length; j++){

            // Store the source-path of the image for later reference.
            let source = images[j].getAttribute('src')

            // Create a UIKit lightbox component.
            let openingTag = '<div uk-lightbox>'

            // Combine a UIKit inline-anchor with the previously stored image-source.
            let openingAnchor = '<a class="uk-inline" href="' + source + '">'

            // Insert a default <img> tag to display the image regardless of javascript is
            // enabled in the users browser or not.
            let imageElement = '<img src="' + source + '">'

            let closingAnchor = '</a>'
            let closingTag = '</div>'

            // Construct the final html string and replace every <img> with the calculated lightbox string.
            images[j].parentNode.innerHTML = openingTag + openingAnchor + imageElement + closingAnchor + closingTag
        }
    }
}

// Run function on page load
window.onload = replaceImgTagWithUIKitLightbox
```

This script allows me to continue inserting images in markdown using ![]() but still utilizing the wonderful lightbox functionality that UIKit provides.

Best wishes,

Florian
