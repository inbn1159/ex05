package org.galapagos.mapper;

import java.util.List;

import org.galapagos.domain.BoardAttachmentVO;
import org.galapagos.domain.BoardVO;
import org.galapagos.domain.Criteria;

public interface BoardMapper {
	public int getTotalCount(Criteria cri);

//	@Select("select * from tbl_board")
	public List<BoardVO> getList();

	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public void insert(BoardVO board);

	public void insertSelectKey(BoardVO board);

	public BoardVO read(Long bno);

	public int delete(Long bno);

	public int update(BoardVO board);
	
	// Upload
	
	public void insertAttachment(BoardAttachmentVO attach);
	
	public List<BoardAttachmentVO> getAttachmentList(Long bno);
	
	public BoardAttachmentVO getAttachment(Long bno);
	
	public int removeAttachment(Long bno);
	
	

}
