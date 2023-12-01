package kr.pe.eta.service.callreq;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.pe.eta.domain.Call;
import kr.pe.eta.domain.Like;
import kr.pe.eta.domain.User;

@Mapper
public interface CallReqDao {

	public List<Call> getEndAddrList(int userNo) throws Exception;

	public List<Like> getLikeList(int userNo) throws Exception;

	public void addLikeList(int userNo) throws Exception;

	public void addCall(Call call) throws Exception;

	public int getCallNo() throws Exception;

	public void deleteCall(int callNo) throws Exception;

	public List<User> getCallDriverList(String carOpt, boolean petOpt) throws Exception;

}
