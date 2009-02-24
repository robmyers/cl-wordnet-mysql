(asdf:operate 'asdf:load-op :clsql)


(defparameter $database "wordnet30")
(defparameter $username "wordnet30_user")
(defparameter $userpass "wnu30access")

(clsql:connect (list "localhost" $database $username $userpass) :database-type :mysql)

;(clsql:start-sql-recording)

;; More specific word

(defun wordnet-hyponyms (word)
  (clsql:query (format nil "select se1.rank,w2.lemma from word w1 left join sense se1 on w1.wordid = se1.wordid left join synset sy1 on se1.synsetid = sy1.synsetid left join semlinkref on sy1.synsetid = semlinkref.synset1id left join synset sy2 on semlinkref.synset2id = sy2.synsetid left join sense se2 on sy2.synsetid = se2.synsetid left join word w2 on se2.wordid = w2.wordid where w1.lemma = '~a' and sy1.pos = 'n' and semlinkref.linkid = 2 order by se1.rank asc;" word)))

;; More general word

(defun wordnet-hypernyms (word)
  (clsql:query (format nil "select se1.rank,w2.lemma from word w1 left join sense se1 on w1.wordid = se1.wordid left join synset sy1 on se1.synsetid = sy1.synsetid left join semlinkref on sy1.synsetid = semlinkref.synset1id left join synset sy2 on semlinkref.synset2id = sy2.synsetid left join sense se2 on sy2.synsetid = se2.synsetid left join word w2 on se2.wordid = w2.wordid where w1.lemma = '~a' and sy1.pos = 'n' and semlinkref.linkid = 1 order by se1.rank asc;" word)))

;; Opposite words

(defun wordnet-adjective-antonyms (word)
  (clsql:query (format nil "select se1.rank, w2.lemma, sy1.definition, sy2.definition from word w1 left join sense se1 on w1.wordid = se1.wordid left join synset sy1 on se1.synsetid = sy1.synsetid left join lexlinkref on sy1.synsetid = lexlinkref.synset1id and w1.wordid = lexlinkref.word1id left join synset sy2 on lexlinkref.synset2id = sy2.synsetid left join sense se2 on sy2.synsetid = se2.synsetid left join word w2 on se2.wordid = w2.wordid where w1.lemma = '~a' and sy1.pos = 'a' and lexlinkref.linkid =30 order by se1.rank asc;" word)))

;; Similar words

(defun wordnet-synonyms (word)
  (clsql:query (format nil "select synsetid, w2.lemma from sense left join word as w2 on w2.wordid=sense.wordid where sense.synsetid in ( select sense.synsetid from word as w1 left join sense on w1.wordid=sense.wordid where w1.lemma='~a' ) and w2.lemma<>'~a';" word word)))
