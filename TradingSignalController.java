package com.cassandrawebtrader.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TradingSignalController {
	
	@RequestMapping("/member/ichimoku")
	public String showIchimokuPage() {
		return "tradingsignal";
	}
	
	@RequestMapping("/member/candlesticks")
	public String showCandlesticksPage() {
		return "candlesticks";
	}

}
