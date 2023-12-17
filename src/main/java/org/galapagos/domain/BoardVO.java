package org.galapagos.domain;

import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class BoardVO {

  private Long bno;
  
  @NotBlank(message="������ �ʼ� �׸� �Դϴ�.")
  private String title;
  
  @NotBlank(message="������ �ʼ� �׸� �Դϴ�.")
  private String content;
  
  @NotBlank(message="�ۼ��ڴ� �ʼ� �׸� �Դϴ�.")
  private String writer;
  
  List<BoardAttachmentVO> attaches;
  
  private Date regDate;
  private Date updateDate;
}

