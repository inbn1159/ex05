package org.galapagos.config;

import javax.sql.DataSource;

import org.galapagos.security.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.web.filter.CharacterEncodingFilter;

import lombok.extern.log4j.Log4j;


@Configuration
@EnableWebSecurity
@Log4j
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
		
	protected void configure(HttpSecurity http) throws Exception {
		
		CharacterEncodingFilter filter = new CharacterEncodingFilter();
		filter.setEncoding("UTF-8");
		filter.setForceEncoding(true);
		
		http.addFilterBefore(filter, CsrfFilter.class);	
		
		http.csrf().ignoringAntMatchers("/api/**");
		
		http.authorizeRequests()
			.antMatchers("/security/profile").authenticated()
			.antMatchers(
					"/board/register",
					"/board/modify",
					"/board/remove").authenticated()
			.antMatchers(
					"/travel/register",
					"/travel/modify",
					"/travel/remove").access("hasRole('ROLE_MANAGER')");
		
		http.formLogin()
			.loginPage("/security/login?error=login_required")	// 로그인 안하고 접근한 경우 리다이렉트
			.loginProcessingUrl("/security/login")
			.defaultSuccessUrl("/")
			.failureUrl("/security/login?error=true");	// el : param.error
		

		http.logout()						// 로그아웃 설정 시작
		  	.logoutUrl("/security/logout")	// POST: 로그아웃 호출 url
		  	.invalidateHttpSession(true)	// 세션 invalidate
		  	.deleteCookies("remember-me", "JSESSION-ID")	// 삭제할 쿠키 목록
			.logoutSuccessUrl("/");	// 로그아웃 이후 이동할 페이지
		
		
		http.rememberMe()		// remember-me 기능 설정
			.key("Galapagos")
			.tokenRepository(persistentTokenRepository())
			.tokenValiditySeconds(7*24*60*60);	// 7일
		
	}

	@Autowired
	private DataSource dataSource;

	@Bean
	public UserDetailsService customUserService() {
		return new CustomUserDetailsService();
	}

	@Override
	protected void configure(AuthenticationManagerBuilder auth)
						throws Exception {

		auth
			.userDetailsService(customUserService())
			.passwordEncoder(passwordEncoder());

	}


	@Bean
	public PersistentTokenRepository persistentTokenRepository() {
		JdbcTokenRepositoryImpl repo = new JdbcTokenRepositoryImpl();
		repo.setDataSource(dataSource);
	
		return repo;
	}

	
}
