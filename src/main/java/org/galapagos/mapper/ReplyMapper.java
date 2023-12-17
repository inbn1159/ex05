package org.galapagos.mapper;

import java.util.List;

import org.galapagos.domain.ReplyVO;

public interface ReplyMapper {
	// List<ReplyVO> readAll(Long cno);
	void create(ReplyVO vo);
	ReplyVO get(Long no);
	void update(ReplyVO vo);
	void delete(Long no);
}
