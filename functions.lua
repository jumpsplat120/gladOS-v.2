function webhook(loc)
	local url = "https://maker.ifttt.com/trigger/" .. loc .. "/with/key/mFngemGW54_R1VbirkFHTecyC6YL0M2V3mcvcXubHR2"
	return http.request(url)
end

