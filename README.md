# iniquity
Third-party class lines that raise an event, allowing any aff tracking to take advantage of them with a simple event handler. 

### Usage:

`raiseEvent("iniquity", method, target, affs)`
eg. `raiseEvent("iniquity", "afflict", matches[2], "paralysis", "dizziness")`

* `"afflict"` method is "all of these affs"
* `"afflict smart"` is "afflict x then y then z"
* `"confirm"` confirms a single affliction
* `"defstrip"` sets the single defense to false