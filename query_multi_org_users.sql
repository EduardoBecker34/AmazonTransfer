SELECT u.userId,
       u.screenName,
       u.emailAddress,
       u.firstName,
       u.lastName,
       o.organizationId,
       o.name AS organizationName,
       ug.userGroupId,
       ug.name
FROM User_ u
LEFT JOIN Users_Orgs uo
  ON (uo.userId = u.userId)
LEFT JOIN Organization_ o
  ON (o.organizationId = uo.organizationId)
LEFT JOIN Users_UserGroups usg
  ON (usg.userId = u.userId)
LEFT JOIN UserGroup ug
  ON (ug.userGroupId = usg.userGroupId)
WHERE u.ldapServerId = 13260812 --LDAP .biz
AND   u.emailAddress LIKE '%@fhlbny.com' --Email ends with @fhlbny.com
AND   u.status = 0 --Active users only
AND   u.firstName + ',' + u.lastName IN (SELECT firstName + ',' + lastName
                                         FROM User_
                                         WHERE ldapServerId = 13260812 --LDAP .biz
                                         AND emailAddress LIKE '%@fhlbny.com' --Email ends with @fhlbny.com
                                         AND status = 0 --Active users only
                                         GROUP BY firstName,
                                                  lastName
                                         HAVING COUNT(*) > 1)
ORDER BY firstName + ',' + lastName, userId;