package kr.pe.eta.domain;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Pay {

	private int userNo;
	private int callNo;
	private String payCode;
	private Date payDate;
	private int money;

}
