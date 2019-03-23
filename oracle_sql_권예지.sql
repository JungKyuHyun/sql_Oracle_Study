--[고난도 문제 연습]

-- 1. EMP 테이블에서 부서 인원이 4명보다 많은 부서의 부서번호, 인원수, 급여의 합을 출력하라.
--select e.deptno
--from emp e 
--join dept d
--on e.deptno = d.deptno
--group by e.deptno, d.dname
--having count(e.deptno)>4;
select deptno, count(deptno), sum(sal)
from emp
where deptno in (select e.deptno
from emp e 
join dept d
on e.deptno = d.deptno
group by e.deptno, d.dname
having count(e.deptno)>4) 
group by deptno;


-- 2. EMP 테이블에서 가장 많은 사원이 속해있는 부서번호와 사원수를 출력하라.

--select deptno
--from emp
--group by deptno
--having count(deptno)=
--(select max(count(deptno))
--from emp
--group by deptno);

select deptno, count(deptno)
from emp
where deptno = (select deptno
from emp
group by deptno
having count(deptno)=
(select max(count(deptno))
from emp
group by deptno))
group by deptno;


-- 3. EMP 테이블에서 가장 많은 사원을 갖는 MGR의 사원번호를 출력하라.

select mgr
from emp
group by mgr
having count(mgr) = 
(
select max(count(mgr))
from emp
group by mgr
);


-- 4. EMP 테이블에서 부서번호가 10인 사원수와 부서번호가 30인 사원수를 각각 출력하라.

select count(deptno) as "사원수"
from emp
where deptno = 10;

select count(deptno) as "사원수"
from emp
where deptno = 30;


-- 5. EMP 테이블에서 사원번호가 7521인 사원의 직업과 같고/사원번호가 7934인 사원의 급여(SAL)보다 많은 사원의/사원번호, 이름, 직업, 급여를 출력하라.


select empno, ename, job, sal
from emp
where job = (
select job
from emp
where empno = 7521
) and
sal > (
select sal
from emp
where empno = 7934
);


-- 6. 직업(JOB)별로 최소 급여를 받는 사원의 정보를 사원번호, 이름, 업무, 부서명을 출력하라.
-- 조건1 : 직업별로 내림차순 정렬


select e.empno, e.ename, e.job, d.dname,e.sal
from emp e
join dept d
on e.deptno = d.deptno
where e.sal in 
(select min(sal)
from emp 
group by job
);

-- 7. 각 사원 별 시급을 계산하여 부서번호, 사원이름, 시급을 출력하라.
-- 조건1. 한달 근무일수는 20일, 하루 근무시간은 8시간이다.
-- 조건2. 시급은 소수 두 번째 자리에서 반올림한다.
-- 조건3. 부서별로 오름차순 정렬
-- 조건4. 시급이 많은 순으로 출력

select e.deptno,d.dname, e.ename, e.sal/160
from emp e, dept d
order by e.sal desc, d.dname;


-- 8. 각 사원 별 커미션이 0 또는 NULL이고 부서위치가 ‘GO’로 끝나는 사원의 정보를 사원번호, 사원이름, 커미션, 부서번호, 부서명, 부서위치를 출력하라.

-- 조건1. 보너스가 NULL이면 0으로 출력

select e.empno, e.ename, e.comm, e.deptno, d.dname, d.loc
from emp e
join dept d
on e.deptno = d.deptno
where e.empno in (select empno from emp where nvl(comm,0) = 0) and
e.empno in (select e.empno from emp e join dept d on e.deptno = d.deptno where d.loc like '%GO');


-- 9. 각 부서 별 평균 급여가 2000 이상이면 초과, 그렇지 않으면 미만을 출력하라.


select case when avg(sal) >= 2000 then'초과'
            ELSE '미만' 
            END
from emp
group by deptno;



-- 10. 각 부서 별 입사일이 가장 오래된 사원을 한 명씩 선별해 사원번호, 사원명, 부서번호, 입사일을 출력하라.


select empno, ename, deptno, hiredate
from emp
where hiredate in (select min(hiredate)
from emp
group by deptno);


-- 11. 1980년~1982년 사이에 입사된 각 부서별 사원수를 부서번호, 부서명, 입사1980, 입사1981, 입사1982로 출력하라.

select count(empno)
from emp
where substr(hiredate,3,2) between 80 and 82
group by deptno;

-- 이거 문제 이해가 안돼서... 80-82년 사이의 각 부서별 사원수를 찾는건지 아니면 80,81,82년도로 나눠야하는건지..ㅠ


-- 12. 1981년 5월 31일 이후 입사자 중 커미션이 NULL이거나 0인 사원의 커미션은 500으로 그렇지 않으면 기존 커미션을 출력하라.

select ename,nvl2(comm,comm,500)
from emp
where hiredate>'1981/05/31';

--turner가 0이 나오는 오류가..

-- 13. 1981년 6월 1일 ~ 1981년 12월 31일 입사자 중 부서명이 SALES인 사원의 부서번호, 사원명, 직업, 입사일을 출력하라.
-- 조건1. 입사일 오름차순 정렬

select e.deptno, e.ename, e.job, e.hiredate , d.dname
from emp e
join dept d
on e.deptno = d.deptno
where (e.hiredate between '1981/06/01' and '1981/12/31') and d.dname = 'SALES';

select e.deptno, e.ename, e.job, e.hiredate , d.dname
from emp e, dept d
where (e.hiredate between '1981/06/01' and '1981/12/31') and d.dname = 'SALES';

--위에 두개다 똑같은 식인데 결과가 다른데 이유가 뭘까요...??


-- 14. 현재 시간과 현재 시간으로부터 한 시간 후의 시간을 출력하라.
-- 조건1. 현재시간 포맷은 ‘4자리년-2자일월-2자리일 24시:2자리분:2자리초’로 출력
-- 조건1. 시간후 포맷은 ‘4자리년-2자일월-2자리일 24시:2자리분:2자리초’로 출력


select to_char(sysdate,'YYYY')||'년' ,to_char(sysdate,'MM')||'월',to_char(sysdate,'DD')||'일',
to_char(sysdate,'HH')||'시',to_char(sysdate,'MI')||'분',to_char(sysdate,'SS')||'초'
from dual;

select to_char(sysdate,'YYYY')||'년' ,to_char(sysdate,'MM')||'월',to_char(sysdate,'DD')||'일',
to_char(sysdate,'HH')+'01'||'시',to_char(sysdate,'MI')||'분',to_char(sysdate,'SS')||'초'
from dual;




-- 15. 각 부서별 사원수를 출력하라.
-- 조건1. 부서별 사원수가 없더라도 부서번호, 부서명은 출력
-- 조건2. 부서별 사원수가 0인 경우 ‘없음’ 출력
-- 조건3. 부서번호 오름차순 정렬

select d.dname ,count(e.deptno)
from emp e
right join dept d
on e.deptno = d.deptno
group by d.dname, d.deptno
order by d.deptno;



-- 16. 사원 테이블에서 각 사원의 사원번호, 사원명, 매니저번호, 매니저명을 출력하라.
-- 조건1. 각 사원의 급여(SAL)는 매니저 급여보다 많거나 같다.

select e.empno, e.ename, e.mgr as "매니저번호", m.ename as "매니저명"
from emp e
join emp m
on e.mgr = m.empno
where e.sal >= m.sal;


-- 18. 사원명의 첫 글자가 ‘A’이고, 처음과 끝 사이에 ‘LL’이 들어가는 사원의 커미션이 COMM2일때, 모든 사원의 
--커미션에 COMM2를 더한 결과를 사원명, COMM, COMM2, COMM+COMM2로 출력하라.

select ename, nvl(comm,0) , (select nvl(comm,0) from emp where ename like 'A%' and ename like '%LL%') as "COMM2" 
, nvl(comm,0)+(select nvl(comm,0) from emp where ename like 'A%' and ename like '%LL%') as "COMM+COMM"
from emp;


-- 19. 각 부서별로 1981년 5월 31일 이후 입사자의 부서번호, 부서명, 사원번호, 사원명, 입사일을 출력하시오.
-- 조건1. 부서별 사원정보가 없더라도 부서번호, 부서명은 출력
-- 조건2. 부서번호 오름차순 정렬
-- 조건3. 입사일 오름차순 정렬

select d.deptno, d.dname, e.empno, e.ename, e.hiredate
from emp e
right join dept d
on e.deptno = d.deptno
where e.hiredate > '1981/05/31'
order by deptno,hiredate;


-- 20. 입사일로부터 지금까지 근무년수가 30년 이상 미만인 사원의 사원번호, 사원명, 입사일, 근무년수를 출력하라.
-- 조건1. 근무년수는 월을 기준으로 버림 (예:30.4년 = 30년, 30.7년=30년)


select empno, ename, hiredate, trunc(MONTHS_BETWEEN(sysdate,hiredate)/12,0)
from emp;

--문제에서 '30년 이상 미만인 ' 이라고 적혀있는데 몇 미만인지 모르겠어서 일단 
--사원명,번호,입사일,근무년수만 기재했습니다.
