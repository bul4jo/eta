package kr.pe.eta;

import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.Assert;

import kr.pe.eta.domain.Notice;
import kr.pe.eta.service.notice.NoticeDao;
import kr.pe.eta.service.notice.NoticeService;

@SpringBootTest
public class NoticeApplicationTests {

	@Autowired
	private NoticeService noticeService;

	@Autowired
	private NoticeDao noticeDao;

	// @Test
	public void testAddNotice() throws Exception {

		Notice notice = new Notice();
		notice.setNoticeDetail("공지사항Generated test");
		notice.setNoticeTitle("공지사항Generated test");

		System.out.println("////////" + notice);

		Assertions.assertEquals(1, noticeService.addNotice(notice));
		// Assertions.assertEquals(1, noticeDao.addNotice(notice));

	}

	// @Test
	public void testGetNotice() throws Exception {

		int noticeNo = 1041;

		// Notice notice = noticeDao.getNotice(noticeNo);
		Notice notice = noticeService.getNotice(noticeNo);
		Assert.notNull(notice);
		System.out.println("///testGetNotice/////" + notice);

	}

	// @Test
	/*
	 * public void testGetNoticeList() throws Exception {
	 * 
	 * Search2 search = new Search2("test", 3, 1);
	 * 
	 * // Notice notice = noticeDao.getNotice(noticeNo); Map<String, Object> notice
	 * = noticeService.getNoticeList(search); Assert.notNull(notice);
	 * System.out.println("///testGetNotice/////" + notice);
	 * 
	 * }
	 * 
	 * // @Test public void testUpdateNotice() throws Exception { Notice notice =
	 * new Notice(1021, "test수정453", "test수정453 입니다."); System.out.println(notice);
	 * noticeService.updateNotice(notice); Assertions.assertEquals(1,
	 * noticeDao.updateNotice(notice)); }
	 */

	// @Test
	public void testDeleteNotice() throws Exception {

		int noticeNo = 1040;

		Assertions.assertEquals(1, noticeService.deleteNotice(noticeNo));

	}

}
