--[���� ���� ����]

-- 1. EMP ���̺��� �μ� �ο��� 4���� ���� �μ��� �μ���ȣ, �ο���, �޿��� ���� ����϶�.
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


-- 2. EMP ���̺��� ���� ���� ����� �����ִ� �μ���ȣ�� ������� ����϶�.

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


-- 3. EMP ���̺��� ���� ���� ����� ���� MGR�� �����ȣ�� ����϶�.

select mgr
from emp
group by mgr
having count(mgr) = 
(
select max(count(mgr))
from emp
group by mgr
);


-- 4. EMP ���̺��� �μ���ȣ�� 10�� ������� �μ���ȣ�� 30�� ������� ���� ����϶�.

select count(deptno) as "�����"
from emp
where deptno = 10;

select count(deptno) as "�����"
from emp
where deptno = 30;


-- 5. EMP ���̺��� �����ȣ�� 7521�� ����� ������ ����/�����ȣ�� 7934�� ����� �޿�(SAL)���� ���� �����/�����ȣ, �̸�, ����, �޿��� ����϶�.


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


-- 6. ����(JOB)���� �ּ� �޿��� �޴� ����� ������ �����ȣ, �̸�, ����, �μ����� ����϶�.
-- ����1 : �������� �������� ����


select e.empno, e.ename, e.job, d.dname,e.sal
from emp e
join dept d
on e.deptno = d.deptno
where e.sal in 
(select min(sal)
from emp 
group by job
);

-- 7. �� ��� �� �ñ��� ����Ͽ� �μ���ȣ, ����̸�, �ñ��� ����϶�.
-- ����1. �Ѵ� �ٹ��ϼ��� 20��, �Ϸ� �ٹ��ð��� 8�ð��̴�.
-- ����2. �ñ��� �Ҽ� �� ��° �ڸ����� �ݿø��Ѵ�.
-- ����3. �μ����� �������� ����
-- ����4. �ñ��� ���� ������ ���

select e.deptno,d.dname, e.ename, e.sal/160
from emp e, dept d
order by e.sal desc, d.dname;


-- 8. �� ��� �� Ŀ�̼��� 0 �Ǵ� NULL�̰� �μ���ġ�� ��GO���� ������ ����� ������ �����ȣ, ����̸�, Ŀ�̼�, �μ���ȣ, �μ���, �μ���ġ�� ����϶�.

-- ����1. ���ʽ��� NULL�̸� 0���� ���

select e.empno, e.ename, e.comm, e.deptno, d.dname, d.loc
from emp e
join dept d
on e.deptno = d.deptno
where e.empno in (select empno from emp where nvl(comm,0) = 0) and
e.empno in (select e.empno from emp e join dept d on e.deptno = d.deptno where d.loc like '%GO');


-- 9. �� �μ� �� ��� �޿��� 2000 �̻��̸� �ʰ�, �׷��� ������ �̸��� ����϶�.


select case when avg(sal) >= 2000 then'�ʰ�'
            ELSE '�̸�' 
            END
from emp
group by deptno;



-- 10. �� �μ� �� �Ի����� ���� ������ ����� �� �� ������ �����ȣ, �����, �μ���ȣ, �Ի����� ����϶�.


select empno, ename, deptno, hiredate
from emp
where hiredate in (select min(hiredate)
from emp
group by deptno);


-- 11. 1980��~1982�� ���̿� �Ի�� �� �μ��� ������� �μ���ȣ, �μ���, �Ի�1980, �Ի�1981, �Ի�1982�� ����϶�.

select count(empno)
from emp
where substr(hiredate,3,2) between 80 and 82
group by deptno;

-- �̰� ���� ���ذ� �ȵż�... 80-82�� ������ �� �μ��� ������� ã�°��� �ƴϸ� 80,81,82�⵵�� �������ϴ°���..��


-- 12. 1981�� 5�� 31�� ���� �Ի��� �� Ŀ�̼��� NULL�̰ų� 0�� ����� Ŀ�̼��� 500���� �׷��� ������ ���� Ŀ�̼��� ����϶�.

select ename,nvl2(comm,comm,500)
from emp
where hiredate>'1981/05/31';

--turner�� 0�� ������ ������..

-- 13. 1981�� 6�� 1�� ~ 1981�� 12�� 31�� �Ի��� �� �μ����� SALES�� ����� �μ���ȣ, �����, ����, �Ի����� ����϶�.
-- ����1. �Ի��� �������� ����

select e.deptno, e.ename, e.job, e.hiredate , d.dname
from emp e
join dept d
on e.deptno = d.deptno
where (e.hiredate between '1981/06/01' and '1981/12/31') and d.dname = 'SALES';

select e.deptno, e.ename, e.job, e.hiredate , d.dname
from emp e, dept d
where (e.hiredate between '1981/06/01' and '1981/12/31') and d.dname = 'SALES';

--���� �ΰ��� �Ȱ��� ���ε� ����� �ٸ��� ������ �����...??


-- 14. ���� �ð��� ���� �ð����κ��� �� �ð� ���� �ð��� ����϶�.
-- ����1. ����ð� ������ ��4�ڸ���-2���Ͽ�-2�ڸ��� 24��:2�ڸ���:2�ڸ��ʡ��� ���
-- ����1. �ð��� ������ ��4�ڸ���-2���Ͽ�-2�ڸ��� 24��:2�ڸ���:2�ڸ��ʡ��� ���


select to_char(sysdate,'YYYY')||'��' ,to_char(sysdate,'MM')||'��',to_char(sysdate,'DD')||'��',
to_char(sysdate,'HH')||'��',to_char(sysdate,'MI')||'��',to_char(sysdate,'SS')||'��'
from dual;

select to_char(sysdate,'YYYY')||'��' ,to_char(sysdate,'MM')||'��',to_char(sysdate,'DD')||'��',
to_char(sysdate,'HH')+'01'||'��',to_char(sysdate,'MI')||'��',to_char(sysdate,'SS')||'��'
from dual;




-- 15. �� �μ��� ������� ����϶�.
-- ����1. �μ��� ������� ������ �μ���ȣ, �μ����� ���
-- ����2. �μ��� ������� 0�� ��� �������� ���
-- ����3. �μ���ȣ �������� ����

select d.dname ,count(e.deptno)
from emp e
right join dept d
on e.deptno = d.deptno
group by d.dname, d.deptno
order by d.deptno;



-- 16. ��� ���̺��� �� ����� �����ȣ, �����, �Ŵ�����ȣ, �Ŵ������� ����϶�.
-- ����1. �� ����� �޿�(SAL)�� �Ŵ��� �޿����� ���ų� ����.

select e.empno, e.ename, e.mgr as "�Ŵ�����ȣ", m.ename as "�Ŵ�����"
from emp e
join emp m
on e.mgr = m.empno
where e.sal >= m.sal;


-- 18. ������� ù ���ڰ� ��A���̰�, ó���� �� ���̿� ��LL���� ���� ����� Ŀ�̼��� COMM2�϶�, ��� ����� 
--Ŀ�̼ǿ� COMM2�� ���� ����� �����, COMM, COMM2, COMM+COMM2�� ����϶�.

select ename, nvl(comm,0) , (select nvl(comm,0) from emp where ename like 'A%' and ename like '%LL%') as "COMM2" 
, nvl(comm,0)+(select nvl(comm,0) from emp where ename like 'A%' and ename like '%LL%') as "COMM+COMM"
from emp;


-- 19. �� �μ����� 1981�� 5�� 31�� ���� �Ի����� �μ���ȣ, �μ���, �����ȣ, �����, �Ի����� ����Ͻÿ�.
-- ����1. �μ��� ��������� ������ �μ���ȣ, �μ����� ���
-- ����2. �μ���ȣ �������� ����
-- ����3. �Ի��� �������� ����

select d.deptno, d.dname, e.empno, e.ename, e.hiredate
from emp e
right join dept d
on e.deptno = d.deptno
where e.hiredate > '1981/05/31'
order by deptno,hiredate;


-- 20. �Ի��Ϸκ��� ���ݱ��� �ٹ������ 30�� �̻� �̸��� ����� �����ȣ, �����, �Ի���, �ٹ������ ����϶�.
-- ����1. �ٹ������ ���� �������� ���� (��:30.4�� = 30��, 30.7��=30��)


select empno, ename, hiredate, trunc(MONTHS_BETWEEN(sysdate,hiredate)/12,0)
from emp;

--�������� '30�� �̻� �̸��� ' �̶�� �����ִµ� �� �̸����� �𸣰ھ �ϴ� 
--�����,��ȣ,�Ի���,�ٹ������ �����߽��ϴ�.
