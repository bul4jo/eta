package kr.pe.eta.service.callreq.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.pe.eta.domain.Call;
import kr.pe.eta.domain.Like;
import kr.pe.eta.domain.User;
import kr.pe.eta.service.callreq.CallReqDao;
import kr.pe.eta.service.callreq.CallReqService;

@Service("callReqService")
public class CallReqServiceImpl implements CallReqService {

	@Autowired
	@Qualifier("callReqDao")
	private CallReqDao callReqDao;

	public CallReqServiceImpl() {
		System.out.println(this.getClass());
	}

	public List<Call> getEndAddrList(int userNo) throws Exception {
		System.out.println("serviceImpl getEndAddrList userNo : " + userNo);

		List<Call> endAddrList = callReqDao.getEndAddrList(userNo);

		return endAddrList;
	}

	public List<Like> getLikeList(int userNo) throws Exception {
		System.out.println("serviceImpl getLikeList userNo : " + userNo);

		List<Like> likeList = callReqDao.getLikeList(userNo);

		return likeList;
	}

	public void addLikeList(int userNo) throws Exception {
		System.out.println("serviceImpl addLikeList userNo : " + userNo);

		callReqDao.addLikeList(userNo);
	}

	public void addCall(Call call) throws Exception {

		callReqDao.addCall(call);
	}

	public int getCallNo() throws Exception {

		int callNo = callReqDao.getCallNo();

		return callNo;
	}

	@Transactional
	public void deleteCall(int callNo) throws Exception {
		callReqDao.deleteCall(callNo);
	}

	public List<User> getCallDriverList(String carOpt, boolean petOpt) throws Exception {
		System.out.println("serviceImpl getCallDriverList carOpt : " + carOpt);
		System.out.println("serviceImpl getCallDriverList petOpt : " + petOpt);

		List<User> callDriverList = callReqDao.getCallDriverList(carOpt, petOpt);

		return callDriverList;
	}

}