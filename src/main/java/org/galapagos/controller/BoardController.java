package org.galapagos.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.galapagos.domain.BoardAttachmentVO;
import org.galapagos.domain.BoardVO;
import org.galapagos.domain.Criteria;
import org.galapagos.domain.PageDTO;
import org.galapagos.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board")
public class BoardController {
	@Autowired
	private BoardService service;

	@ModelAttribute("searchTypes")
	public Map<String, String> searchTypes() {
		Map<String, String> map = new LinkedHashMap<String, String>();
		map.put("", "-- 검색대상선택 --");
		map.put("T", "제목");
		map.put("W", "작성자");
		map.put("C", "내용");
		map.put("TC", "제목+내용");
		map.put("TW", "제목+작성자");
		map.put("TWC", "제목+작성자+내용");
		
		return map;
	}	
	
	@GetMapping("/list")
	public void list(@ModelAttribute("cri") Criteria cri, Model model) {
	
		log.info("list" + cri);
		int total = service.getTotal(cri);//		model.addAttribute("list", service.getList());
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));	// �엫�쓽濡� 123  �슂泥�

	}
	
	@GetMapping("/register")
	public void register(@ModelAttribute("board") BoardVO board) {	
		log.info("register");	
	}

	@PostMapping("/register")
	public String register(
			@Valid @ModelAttribute("board") BoardVO board,
			Errors errors,
			List<MultipartFile> files,
			RedirectAttributes rttr) throws Exception {

		log.info("register: " + board);
		if(errors.hasErrors()) {
			return "board/register";
		}

		service.register(board, files);

		rttr.addFlashAttribute("result", board.getBno());

		return "redirect:/board/list";
		

	}
	
	@GetMapping({ "/get", "/modify" })
	public void get(
			@RequestParam("bno") Long bno,
			@ModelAttribute("cri") Criteria cri,
			Model model) {

		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}
	
	@PostMapping("/modify")
	public String modify(
			@Valid @ModelAttribute("board") BoardVO board,
			Errors errors,
			List<MultipartFile> files,
			@ModelAttribute("cri") Criteria cri,
			RedirectAttributes rttr) throws Exception {
		log.info("modify:" + board);
	
		if(errors.hasErrors()) {
			return "board/modify";
		}		
		
		
		if (service.modify(board, files)) {
			// Flash --> 1�쉶�꽦
			rttr.addFlashAttribute("result", "success");
//			rttr.addAttribute("bno", board.getBno());
//			rttr.addAttribute("pageNum", cri.getPageNum());
//			rttr.addAttribute("amount", cri.getAmount());
//			rttr.addAttribute("type", cri.getType());
//			rttr.addAttribute("keyword", cri.getKeyword());

		}
//		return "redirect:/board/get";
		return "redirect:" + cri.getLinkWithBno("/board/get", board.getBno());
		

	}

	
	@PostMapping("/remove")
	public String remove(
			@RequestParam("bno") Long bno, 
			@ModelAttribute("cri") Criteria cri,
			RedirectAttributes rttr) {
	
		log.info("remove..." + bno);
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
//			rttr.addAttribute("pageNum", cri.getPageNum());
//			rttr.addAttribute("amount", cri.getAmount());
//			rttr.addAttribute("type", cri.getType());
//			rttr.addAttribute("keyword", cri.getKeyword());
		}
//		return "redirect:/board/list";
		return "redirect:/board/list" + cri.getLink();

	}
	
	@GetMapping("/download/{no}")
	@ResponseBody
	public void download(@PathVariable("no") Long no,
			HttpServletResponse response) throws Exception {
		BoardAttachmentVO attach = service.getAttachment(no);
		attach.download(response);
	}
	
	@DeleteMapping("/remove/attach/{no}")
	@ResponseBody
	public String removeAttach(@PathVariable("no") Long no) throws Exception {
		service.removeAttachment(no);
		return "OK";
	}
	

}
