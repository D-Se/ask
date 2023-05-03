#`?` <- \(., query = NULL) .Call(c_ask, ., query, parent.frame(), PACKAGE = "ask")
`?` <- \(., query = NULL) {
	if (is.logical(.)) {
		.Call(c_cf, ., query, parent.frame(), PACKAGE = "ask")
	} else {
		.Call(c_ask, ., substitute(query), parent.frame(), PACKAGE = "ask")
	}
}
