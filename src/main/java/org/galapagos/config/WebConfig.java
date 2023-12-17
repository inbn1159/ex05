package org.galapagos.config;

import javax.servlet.Filter;
import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer{

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] { RootConfig.class, SecurityConfig.class };
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] { ServletConfig.class };
	}

	@Override
	protected String[] getServletMappings() {
		return new String[] { "/" };
	}
	
	
    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter characterEncodingFilter = 
        		new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);
        
        return new Filter[] {characterEncodingFilter};
    }

    
	@Override
	protected void customizeRegistration(Dynamic registration) {
		registration.setInitParameter(
				"throwExceptionIfNoHandlerFound", "true");
		
	}

//	Servlet 3.0 파일 업로드 사용시
//	@Override
//	protected void customizeRegistration(Dynamic registration) {
//		int MEGA = 1024*1024;
//		registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");
//		MultipartConfigElement multipartConfig =
//				new MultipartConfigElement(
//						"c:/temp/upload",	// 업로드 디렉토리 경로
//						20*MEGA,			// 업로드 가능한 파일 하나의 최대 크기 
//						40*MEGA,			// 업로드 가능한 전체 최대 크기(여러 파일 업로드 하는 경우)
//						20*MEGA				// 메모리 파일의 최대 크기(이보다 작으면 실제 메모리에서만 작업)
//					);		
//		registration.setMultipartConfig(multipartConfig);
//	}
    
}

