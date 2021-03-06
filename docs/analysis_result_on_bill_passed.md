---
title: "Research Analysis and Result"
author:
- name: 江廷振
  affiliation: 國立臺灣大學法律學系碩士班
output:
  html_document:
    keep_md: yes
  word_document: default
  github_document: default
---




# 實證研究

## 研究設計

基於研究探討的是立法委員回應民意的各種現象前提下，顧及民意變動的速度以及變動的可能，為準確、精準探討現象，將立法委員行為與民意對應的範圍限縮至問卷調查做成後一年內的投票表決行為。

我透過向SRDA學術調查研究資料庫<https://srda.sinica.edu.tw/>申請臺灣社會變遷基本調查「2016第七期第二次：公民與國家組」、「2010第六期第一次：環境組」、「2010第六期第一次：綜合組」的限制版資料，作為民意資料，同時將各問卷以「2016第七期第二次：公民與國家組」的過錄編碼簿標準合併。限制版的資料與一般版不同處在於包含有受訪對象的戶籍地村里層級資料，藉此可以與準確地與選區資料合併。研究上選擇這三組調查樣本，第一是因為這三組資料均同時含有基本資料（人口變項）、政策議題調查以及政治參與的資料，第二是因為這三組資料的政策意向問題較多，涵蓋層面較廣而全面（2010年兩組樣本的政策意向問題合併後共有101題、2016公民與國家組的政策意向約共有76題），能夠貼近人們的政策偏好不僅限單一面向或群體利益導向政策的情形，同時對於研究工作而言也能夠在一次的議案編碼後對應比較多問卷調查題目而比較有效率，研究發現與結論有較高的建構效度。

控制選區：控制選區的重要性在於不同的選區會有不同的議題導向與利益需求，農業縣與都會商業區可能選民意向以及利益就截然不同。為了排除此項因素的干擾，更聚焦於選民對於立法委員的影響，此處會對於選區控制區別。

驗證方向：

* 菁英觀點，接近Ely一派代表性補強論的角度，其假說為立法委員在敘述代表（相似）性上與選民越不相似時，因為偏見或歧視或觀點不一致，因而越不回應選民的需求，敘述代表性越低者越弱勢。虛無假設：不論選民與立法委員之間的敘述代表相似性如何，立法委員回應選民的程度一致。控制選民參與政治程度。
* 民主政治的多元主義論，Dahl、Ackerman一派，假說為選民可以動員影響立法委員，動員越強或參與政治程度越高時，立法委員受選民壓力越高越回應選民，影響力越低者（通常可能是參與政治程度越低者）越弱勢。虛無假設：選民不論社經地位或參與政治差異，立法委員回應的程度一致。控制敘述代表性。

也可以透過與不分區立委（政黨紀律較高因而partisanship較高）與區域立委回應選民的程度對照，若區域立委回應程度較高，也顯示多元主義論較優，菁英論較劣。

在請願或抗議的人裡面，是不是又有哪些人影響力較高？

在驗證理論外，並同時探索影響回應性的因素。

## 資料來源、處理以及變項的建立

首先利用立法院議事暨公報管理系統 <https://lci.ly.gov.tw/LyLCEW/lcivAgendarecMore.action> 檢索立法院院會的議事錄網址，以R軟體爬蟲取得各個議事錄的HTML原始碼，接著將議事錄中文件結尾處的記名表決結果名單內容結構化處理，並透過比對議事錄內容中記名表決關鍵字（以正規表達式搜尋）以及事後檢查檢核並修正議事錄中出現的一些規律的文字表述結構，形成一個包含有立法院屆次、會期、會議次、臨時會次、案由、投票表決議案編號、概略案由、立法委員姓名與投票決定（包含贊成、反對、棄權、未出席、未投票）的立法院表決紀錄資料集（原本研究要利用g0v的「立委投票指南網站」（<https://vote.ly.g0v.tw/>）的資料集，但後來發現有錯誤，於是僅部分參考其公開的程式碼中的演算法與靈感，並修正其錯誤）。接著與立法院開放資料服務平台提供的歷屆委員資料 <http://data.ly.gov.tw/listcatelog.action?catCd=2> －－包含屆別、姓名、性別、黨籍、黨團、選區名稱、學經歷－－等屬性的資料集以及中央選舉委員會的選舉資料庫資料集<https://data.gov.tw/dataset/13119>、選舉資料庫<http://db.cec.gov.tw/histCand.jsp>、歷史選舉公報<http://bulletin.cec.gov.tw/bin/home.php>串連以增加立委個人基本資料的欄位。此處並建立以下變項（以下部分只要是類別變項，均為虛擬變項，作者使用的R語言分析時能夠自動轉換為虛擬變項）：

* 立法委員性別：根據中選會資料以及立法院的立法委員個人資料判斷編碼。
* 立法委員受教育年數：根據中選會資料以及立法院的立法委員個人資料判斷，以國中9、高中/高職12、大專/專科/大學16、研究所/碩士19、博士23編碼。
* 立法委員院外／從政前社經地位：除去立法委員身份，依據立法委員主要的院外職業或是擔任立法委員前主要的經歷與職業，參考{黃毅志, 2008 #12731}編碼得出連續變項。盡量蒐集並依據最早期從政參選時的選舉公報資料為主。若僅有黨職、聯誼性社團經歷而無其他經歷時，則定位其職業為民意代表，大部分有此類特徵者在選舉公報上面的職業都記載社會服務或是政治工作，地方派系勢力、年輕從政的政二代也多是此模式；如果是從政治人物幕僚開始一路往上爬的政治人物，未經過國會助理（不包含國會辦公室主任此一管理職）或是智庫研究員歷練的也編入民意代表。
* 立法委員所屬族群（還沒編）：依據資料來源為選舉公報、新聞、網頁資料進行編碼，客家政治人物資料來源並參考{何來美, 2017 #12749}，分為台灣閩南人、台灣客家人、大陸各省市、台灣原住民、外裔或原國籍為外籍或原國籍中國大陸的新移民、前述分類以外的臺灣人。
* 立法委員傾向政黨立場比率（自變項）：參考{黃秀端, 2006 #12613}的作法，依據一表決議案中與觀察值立法委員做出相同立場投票（決定）的同黨籍立法委員數，除以該議案中同黨籍立法委員的決定總數的數值連續變項編碼。此變項其實也相當於政黨動員比率／政黨施壓率。分母所謂同黨籍立法委員的決定總數，也把未出席院會、棄權、出席院會但不投票也視為一種決定。
* 立法委員的議案決定是否屬於同黨籍立法委員多數意見（自變項）：用以類比對照前述立法委員傾向政黨立場比率，如果立法委員傾向政黨立場比率大於0.5，編碼為是，否則為否的類別虛擬變項。

在民意資料中，將整個民意資料集以各個政策意向的問題為對照基礎，將資料從短資料轉換為長資料－－也就是一個觀察值從代表一個受訪者的全部變數，轉換為代表一個政策議題意向的全部變數－－，並且選擇以下幾個與本研究有關的項目並處理編碼：

* 區域立法委員投票傾向：2016公民與國家組的臺灣社會變遷基本調查資料集中，首先依據「請問在這次區域立委選舉,您投給哪一個政黨的候選人?」以及「請問在這次區域立委選舉,您投給哪一個政黨的候選人?(90)忘記或不知道政黨,請記錄候選人姓名」等題項決定有關選民投票支持的區域立法委員候選人黨籍；接著進行檢誤，如果經檢誤發現受訪對象回答的政黨在受訪對象的戶籍地（zip欄位）並未派出候選人（例如臺北市大同區在2016年並無國民黨候選人參選，但戶籍位於該區的受訪者回答投票給國民黨候選人）參選時，則與「忘記了、不知道」、「跳答」、「拒答」、「遺漏值」等選項一併視為遺漏值。接著透過「請問您投票給哪一組候選人?」、「請問在這次區域立委選舉,您投給哪一個政黨的候選人?」、「下面我們列出這次參加不分區立委選舉的政黨,請問您把票投給哪一個政黨?」、「國內的政黨都有他們的支持者,請問您是哪一個政黨的支持者?」、「一般而言,請問您會比較偏向哪一個政黨?」等題目所回答的答案計算政黨傾向，每一題計算一分，分為泛藍傾向（較支持國民黨、親民黨、新黨等政黨及其候選人）得分以及泛綠傾向（較支持民進黨、臺灣團結聯盟、時代力量與綠黨等政黨及其候選人）得分。最後以R語言軟體mice套件{van Buuren, 2011 #12742}中的隨機森林（random forests）演算法依據「郵遞區號」、「泛藍傾向得分」、「泛綠傾向得分」等自變項進行機器學習的遺漏值填補，填補後並進行觀察，如果泛藍或泛綠傾向大於3分卻填補為非自身傾向的候選人，或是填補的值仍然沒有該政黨的候選人參選時，將填補的答案重新處理為遺漏值後再一次重新填補，以迴圈方式反覆進行。在2016公民與國家組1966個觀察值中共有656個遺漏值，填補至剩下17個遺漏值。2010綜合的調查資料「請問您在區域選舉部分是投給那一黨的立法委員候選人?」也用同樣的方式處理，在1967個觀察值中將952個遺漏值填補到剩下39個遺漏值。2010環境的資料則以「目前國內有幾個主要政黨,請問您有沒有比較偏向哪一個政黨?」為主。經過與SRDA與台灣社會變遷調查聯絡，誤答的原因「……可能為受訪者記錯、訪員點錯、抽樣時內政部的戶籍地資料不是最新版…等各種狀況」。
* 議題領域：分為經濟、公民與政治權、社會福利、財政、內政、兩岸、環境、經濟社會文化權。
* 同政策意向者佔全國／全選區整體意向比率（自變項）：分別以全國／全選區層級中與觀察對象持同方向政策意向者人數除以全部人數所得數值編碼。Likert量表設計的問題中，將回答非常贊成與贊成某政策者編為同一類，非常反對／反對某政策者編為同一類。這個指標也就是要衡量觀察對象的政策意向連結整體層級的民意強度。
* 意向強度（自變項）：如果題目問題設計以五等Likert量表或四等強迫回答（選邊站）設計的問題中，贊成、反對等選項編碼為1，非常贊成、非常反對等選項編碼為2。若題目設計僅有三等（贊成、反對、無意見）或強迫回答的二等時，均編碼為1，其餘無意見或遺漏值編碼為0，為依順序變項。
* 族群（自變項）：三個問卷的問題皆有共同的「父母親是哪裡人」的兩個選擇題及開放填充題，我將此題目依據答案重新編碼為父母親分別為台灣閩南人、台灣客家人、大陸各省市、台灣原住民、外裔或原國籍為外籍或原國籍中國大陸的新移民、前述分類以外的臺灣人（例如有部分受訪者的父母親是「外省人第二代」，而在開放填充題中回答臺灣人）。接著依照廣義的原生論（primordialism），只要父母有其一為人口比例較少的較少數族群者，則一律視為較少數族群。為類別變項。
* 所屬族群人口比例（自變項）：將前述的族群類別變項，依據各族群佔全國人口比例編碼為數值的連續變項。人口比例的資料來自於行政院客家委員會委託研究的「99年至100年全國客家人口基礎資料調查研究」以及「105年度全國客家人口暨語言調查研究報告」<https://www.hakka.gov.tw/Content/Content?NodeID=626&PageID=37585>、內政部戶政司人口資料庫<https://www.ris.gov.tw/zh_TW/346>、內政部移民署業務統計資料<https://www.immigration.gov.tw/lp.asp?ctNode=29699&CtUnit=16434&BaseDSD=7&mp=1>。
* 教育程度（自變項）：以受教育年數為準（2016的問題為「從國小一年級算起,請問您總共受幾年的學校教育?」，其優點為可轉換為連續變項較為準確且反應人力資本的投資程度），2010環境組與綜合組資料則依據無/不識字0、自修(識字/私塾)0、小學6、國(初)中9、初職9、高中12、綜合高中12、高職12、士官學校14、五專14、二專14、三專15、軍警校專修班13、軍警校專科班14、空中行(商)專15、空中大學16、軍警官學校/大學16、技術學院,科大16、大學16、碩士19、博士23重新編碼為受教育年數。
* 家庭收入（自變項）：主要依據為家庭收入，問卷問題為「包括各種收入來源,您全家人的所有收入,每個月大約多少元?」，原調查得到的資料為根據每組不同所得範圍的區間，此處重新根據各組組中點的編碼為收入，最低一組（無收入）為0，最高一組（100萬元以上）編碼為150,000。
* 職業社經地位（自變項）：~~因素分析（Factor Analysis），透過收入、職業、受教育年數、轉軸後萃取出社經地位，還沒轉~~ 以各問卷中的「工作主要的職位和工作內容是?變遷職位碼」欄位參考黃毅志（2008）轉換得出一社經地位的量化連續尺度變項。
* 綜合社經地位（自變項）：從教育程度、家庭收入及職業社經地位，以因素分析法萃取出成分。
* ~~工作狀態（自變項）：略~~
* 政治效能感（自變項）：分為外在效能感與內在效能感。外在效能感部分主要依據題目為「請問您同不同意以下的說法?在台灣,一般民眾影響環保政策的機會非常有限」（2010環境）、「請問您贊不贊成一般公民也可以影響政府的決策的說法?」（2010綜合）、「一般公民對政治都有相當的影響力」（2016公民）作為標準。另外以「請問您覺得自己平日的環保行為,對於改善台灣的環境品質有沒有用?」（2010環境）、「請問您贊不贊成只要經常提出意見,像我們這樣的人也能影響社會的發展的說法?」（2010綜合）、「像您這樣的人,對政府的作為沒有任何影響力」（2016公民）作為內在效能感指標。
* ~~相對剝奪感／對現狀的評價（自變項）：還沒編。「您覺得政府現行的環境保護政策符不符合公平正義的原則?」~~
* 政治參與：由於三份問卷的政治參與題目與選項不同，經檢視分析後，為保留最大資訊量，重新構建出幾個構念變項（可以透過因素分析濃縮？）：
    + 是否投票（自變項）：包含2010綜合的「前年立法委員選舉(民國97年1月)的時候,請問您有沒有去投票?」、2010環境的「請問您上一次總統選舉(97年3月)有沒有去投票?」、2016公民的「在這一次(一月十六日)舉行的總統大選中,請問您有沒有去投票?」，選項編碼為有、無、沒有投票權、遺漏值，為類別變項。
    + 是否曾經透過接觸政治人物如民意代表或政府官員提出訴求，或者連署及請願（自變項）：包含2010綜合的「在過去的一年,您有沒有向政府官員,民意代表或政黨反映意見提出要求?」（選項為多次、曾有過、從未有過、遺漏值）、2010環境的「在過去五年間,請問您有沒有做過以下的事情:連署一份有關環保議題的請願書」（選項為有、沒有、遺漏值）、2016公民的「您過去有沒有做過或將來會不會做這些事?a請願(簽名)連署／e找政治人物或公職人員表達您的看法」（選項為有做過：過去一年中您有做過這件事；有做過：在更早以前您有做過這件事；沒有做過：就算過去沒有做過,將來您有可能做這件事；沒有做過：過去沒有做過,而將來無論在什麼情形下您也不會做這件事；遺漏值）。重新定義選項並編碼有做過、沒做過、遺漏值；2016公民的兩個題目合併，只要其中任一項有做過就編碼為有做過。為類別變項。
    + 是否曾經參與集會遊行抗議（自變項）：包含2010綜合「在過去的一年,您有沒有參加遊行,示威,靜坐或其他自力救濟方式?」、2010環境「在過去五年間,請問您有沒有做過以下的事情:參加有關環保議題的抗議行動或遊行」、2016公民的「您過去有沒有做過或將來會不會做這些事?c參加示威遊行／b參加抗議不公不義的活動」。選項的尺度均與前面連署及請願、接觸政治人物的原始問卷選項相同。此處重新定義選項並編碼為有參加過、沒參加過、遺漏值。為類別變項。

隨後我以表決紀錄資料集調整縮減欄位建立表決議案的資料集，在此資料集中建立與議案與民意之間的關係以及議案屬性。在建立完成關連之後，透過SPSS軟體將資料檔輸出過錄編碼簿（也就是每一個問題有哪些答案的資料集），接著將此過錄編碼簿串連前述表決議案資料集，並且針對每一個議案與答案選項的關連編碼出「議案的立場」。特別需要說明的是某些表決議案涉及多方向利益角力的編碼方式，舉兩個代表案例說明，首先是立法院第7屆第6會期第14次會議第24表決議案<https://lci.ly.gov.tw/LyLCEW/html/agendarec/02/07/06/14/LCEWC03_070614.htm>，涉及的是當時二代健保的補充保費修正案，表決結果決定新增補充保費，費用來源為獎金、兼職薪資所得、執行業務收入、股利所得、利息所得、租金收入（被稱為林志玲條款）。相對應的題目是2010綜合問卷的「您是不是贊成如果大家的收入更平均的話,一般人會因此更不努力工作的說法?」（回答：1非常贊成;2贊成;3不贊成;4非常不贊成;……其他遺漏值）以及「有人說:減少高收入與低收入之間的差距,是政府的責任,請問您同不同意?」（回答：1非常同意;2同意;3無所謂同不同意;4不同意;5非常不同意;……其他遺漏值）。補充保費的決定實施看似比原先舊制更往所得重分配的方向走，但如果檢視立法過程中的對案可以發現反對所得重分配的利益並沒有全輸，因為反對陣營的對案中的「退職金、海外所得、買賣資產所得」並未被納入，在此種情形下，我的編碼方式是將此議案與兩個問題建立兩次的關連，接著在「議案的立場」方面，第一次的關連編碼回應了贊成所得重分配者的意見，第二次的關連編碼回應了反對所得重分配者的意見。同樣的情形發生在立法院第9屆第2會期第13次會議第2表決議案<https://lci.ly.gov.tw/LyLCEW/html/agendarec1/02/09/02/13/LCEWC03_090213.htm>，涉及的是勞基法一例一休修法中以休息日加班要發加倍加班費的改變，相關連的題目是2016公民的「請問您是贊成還是反對?f透過減少每個人的工作時數,讓更多的人可以工作」（回答1很贊成;2贊成;3既不贊成也不反對;4反對;5很反對;……其他遺漏值）及「應不應該是政府的責任?e為工商業成長所需提供協助」（回答1當然應該;2還算應該;3不太應該;4當然不應該;……其他遺漏值），議案本身表面上看起來與舊制相比回應了贊成減少工時者以及認為政府不應該透過減少工時協助工商業成長者的意見，但檢視對案可以看到這方面的利益也並未完全勝利，因為「二例假日」的訴求並未成功，在此情形下也一樣建立兩次關連，而有關「議案的立場」則分別給予相反的編碼。

在上述資料集處理完成後分別將各個資料集串聯中央選舉委員會在政府資料開放平台釋出的選舉資料庫<https://data.gov.tw/dataset/13119>（並且修正若干錯誤）後將各個資料集增加選舉屬性資料。接著，選擇各個民意調查做成後一年期間（也就是2010年7月至2011年6月、2016年8月至2017年5月）內的表決紀錄資料，以這段期間的資料為準再將資料串連合併。串聯合併條件分別是將選區選民（受訪者）和該選區立法委員串在一起，以及不分選區將所有立法委員和所有選民串在一起，這也分別就是立法委員代表全國選民以及立法委員代表選區選民的情形，同時也落實前面研究設計所提到的控制選區的問題；串聯方式為inner join，也就是僅留存有共同欄位的值相同的觀察值。總計在此期間內有147個表決議案可以對應到問卷的問題。建立變項如下：

* 立法委員與選民年齡差距（自變項）：以立法委員的年齡減去選民的年齡後，取絕對值。為測量敘述代表性的連續變項。
* 立法委員性別與選民性別是否一致（自變項）：一致編碼為1，不一致編碼為0，為測量敘述代表性的類別變項。
* 立法委員社經地位與選民社經地位差距（自變項）：以前述建立的立法委員院外社經地位，減去選民的社經地位後，取絕對值。為測量敘述代表性的連續變項。
* 立法委員受教育年數與選民受教育年數差距（自變項）：以前述建立的立法委員受教育年數，減去選民的受教育年數後，取絕對值。為測量敘述代表性的連續變項。~~透過立法委員與選民間的受教育年數差距、職業五等分差距，因素分析後萃取出N個因素~~
* 立法委員族群與選民族群是否一致（自變項，還沒編）：依據先前所建立的立法委員族群以及選民族群變項進行判斷，一致編碼為1，不一致編碼為0，為測量敘述代表性的類別變項。
* ~~立法委員與選民敘述代表性整體差距：因素分析萃取~~
* 是否回應民意（應變項）：對照前述處理資料所建立的「議案的立場」，若選民的立場與議案的立場一致，而立法委員投票贊成時，編碼為3（回應），投票反對時編碼為0（拒絕）；選民的立場與議案的立場相反而立法委員投票反對時，編碼為3（回應），投票贊成時編碼為0（拒絕）；投下棄權票時，編碼為2（棄權）；立法委員未出席會議、出席會議但未投票，編碼為1（忽略）。研究在此先將「忽略」的情形獨立出來，僅於必要以及敘述統計時利用，不納入研究。其餘的「拒絕」、「棄權」以及「回應」，則有明顯的順序關係，此為一有順序（ordinal）關係的類別變項。

每一個觀察值代表一個意見，共計觀察值數目：

```
## [1] 714676
```

資料檢核後，各變項遺漏值如下：

```
##                                            SURVEY 
##                                                 0 
##                                                id 
##                                                 0 
##                                               zip 
##                                                 0 
##                                          stratum2 
##                                                 0 
##                                    myown_areakind 
##                                                 0 
##                                               psu 
##                                                 0 
##                                               ssu 
##                                              7050 
##                                              wsel 
##                                                 0 
##                                        myown_wsel 
##                                                 0 
##                                              wave 
##                                                 0 
##                                              year 
##                                                 0 
##                                            year_m 
##                                                 0 
##                                         myown_sex 
##                                                 0 
##                                         myown_age 
##                                               150 
##                                myown_dad_ethgroup 
##                                              1700 
##                                myown_mom_ethgroup 
##                                              2466 
##                                      myown_selfid 
##                                              1058 
##                           myown_selfid_population 
##                                              1058 
##                                    myown_marriage 
##                                               342 
##                                    myown_religion 
##                                            340186 
##                                       myown_eduyr 
##                                             30364 
##                            myown_int_pol_efficacy 
##                                             14828 
##                            myown_ext_pol_efficacy 
##                                             22480 
##          myown_approach_to_politician_or_petition 
##                                              6904 
##                                     myown_protest 
##                                              5100 
##                                        myown_vote 
##                                             18772 
##                     myown_constituency_party_vote 
##                                                 0 
##                              myown_working_status 
##                                               304 
##                                    myown_industry 
##                                             21392 
##                                         myown_job 
##                                                 0 
##                                        myown_occp 
##                                             57590 
##                                         myown_ses 
##                                             57590 
##                             myown_workers_numbers 
##                                            419776 
##                                  myown_job_status 
##                                            714676 
##                              myown_hire_people_no 
##                                               538 
##                            myown_manage_people_no 
##                                              2570 
##                       myown_family_income_ingroup 
##                                                 0 
##                               myown_family_income 
##                                            125730 
##                       myown_family_income_ranking 
##                                            125730 
##                         myown_family_income_stdev 
##                                            125730 
##                                  variable_on_term 
##                                                 0 
##                                              term 
##                                                 0 
##                                      electionarea 
##                                            191202 
##                                         admincity 
##                                            191202 
##                                     admindistrict 
##                                            191202 
##                                           village 
##                                            714676 
##                                      adminvillage 
##                                            714676 
##                                  SURVEYQUESTIONID 
##                                                 0 
##                                 SURVEYANSWERVALUE 
##                                                 0 
##                   same_pos_to_all_ratio_by_nation 
##                                                 0 
##             same_pos_to_all_ratio_by_electionarea 
##                                                 0 
##                                            period 
##                                                 0 
##                                         meetingno 
##                                                 0 
##                                   temp_meeting_no 
##                                                 0 
##                                             billn 
##                                                 0 
##                                        billresult 
##                                                 0 
##                                      billid_myown 
##                                                 0 
##                               value_on_q_variable 
##                                                 0 
##                                     variable_on_q 
##                                                 0 
##                                             LABEL 
##                                                 0 
##                                          QUESTION 
##                                                 0 
##                            opinionfromconstituent 
##                                                 0 
##                                   opinionfrombill 
##                                                 0 
##                                      issue_field1 
##                                                 0 
##                                      issue_field2 
##                                            345262 
##                                   opinionstrength 
##                                             79679 
##                   opiniondirectionfromconstituent 
##                                                 0 
##                          opiniondirectionfrombill 
##                                                 0 
##                                   success_on_bill 
##                                                 0 
##       opinion_pressure_from_constituent_by_nation 
##                                                 0 
##       majority_opinion_from_constituent_by_nation 
##                                                 0 
## opinion_pressure_from_constituent_by_electionarea 
##                                                 0 
## majority_opinion_from_constituent_by_electionarea 
##                                                 0
```

## 模型與研究假設

由於應變項為次序變項，不同類別之間雖有次序關係但間隔可能不等距，迴歸分析使用ordinal logit models{Agresti, 2010 #12745}

有沒有需要使用Structural  Equation  Model,  SEM或是Multilevel Model, MLM(可能不同選區有不同選區的特性？)



## 信度檢測（還沒做）

Cronbach’s α

## 共線性檢測（還沒做）

共線性檢測：可以用correlation analysis相關係數矩陣、VIF test(超過10 drop)
http://r-statistics.co/Model-Selection-in-R.html （also tutorial on stepwise）

## 預測失準可能檢測

Heteroscedasticity: prediction必須要隨機分布，不能有pattern，否則導致模型失準； spot outliers

## 研究結果與發現

standardized beta coefficient

https://www.princeton.edu/~otorres/LogitR101.pdf
https://stats.idre.ucla.edu/r/dae/ordinal-logistic-regression/
https://www.jakeruss.com/cheatsheets/stargazer/


### 立法委員回應民意的情形會因為執政與在野不同，且不一定受民意多數的影響

首先發現一個值得注意的現象。選民影響力與國會議員行為研究間關係的始祖{Miller, 1963 #12740}發現，民意在一定程度上會影響民意代表的行為。但在本研究發現顯示，在2010年7月至2011年6月（以下簡稱第七屆研究範圍期間）以及2016年8月至2017年5月（以下簡稱第九屆研究範圍期間）兩段期間中，民意是否佔多數對於立法委員是否回應民意而言，影響程度卻是不一定，包含是否顯著影響、效應的方向及大小皆有不同：第七屆研究範圍期間立委的行為與多數民意呈現顯著方向相反的關係，第九屆研究範圍期間立委的行為則是顯著跟著民意多數變化，但效應不高。但是，同樣當立法委員意向越傾向政黨，黨性越強（stronger partisanship）時，越傾向不回應民意。（立法委員回應民意與民意多數、政黨意見多數間關係分析表；report其他統計指標）




```r
#stargazer(model_influce_from_p_p.k.2,model_influce_from_p_p.k.3,model_influce_from_p_p.k.4,model_influce_from_p_p.k.5,model_influce_from_p_p.d.2,model_influce_from_p_p.d.3,model_influce_from_p_p.d.4,model_influce_from_p_p.d.5, title="立法委員回應民意與民意佔比、同黨成員意見佔比間關係分析表", align=TRUE, type = 'html', summary=TRUE, notes="model 1,2,3,4 為第七屆研究範圍期間,model 5,6,7,8 為第九屆研究範圍期間")
```

為了探究這種與一般直覺相左的原因，瞭解民意代表為何會選擇不回應民意，此處先區分時期、區分政黨回應民意的情形，以箱型圖觀察如下：


```r
#rm(model_influce_from_p_p.k.2,model_influce_from_p_p.k.3,model_influce_from_p_p.k.4,model_influce_from_p_p.k.5,model_influce_from_p_p.d.2,model_influce_from_p_p.d.3,model_influce_from_p_p.d.4,model_influce_from_p_p.d.5)
#gcreset()
glmdata %>%
  dplyr::filter(!is.na(success_on_bill)) %>% ggplot(aes(x=success_on_bill, y=opinion_pressure_from_constituent_by_nation)) + labs(title = "第七屆與第九屆研究範圍期間立法委員回應民意與全國民意佔比間關係") + facet_grid(term ~ .) + geom_boxplot()
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
glmdata %>%
  dplyr::filter(!is.na(success_on_bill)) %>%
  ggplot(aes(x=success_on_bill, y=opinion_pressure_from_constituent_by_electionarea)) + labs(title = "第七屆與第九屆研究範圍期間立法委員回應民意與立法委員選區多數民意佔比間關係") + facet_grid(term ~ .) + geom_boxplot()
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-6-2.png)<!-- -->

從箱型圖中可以發現兩個時期的在野黨均明顯較執政黨更回應民意多數。這一點與{Miller, 1963 #12740}的研究發現指出非現任者會傾向更回應民意一點有相似的現象。
將政黨席次與執政黨席次的差距作為自變項加回迴歸式進行檢定。




```r
#stargazer(model_influce_from_p_p_s.k.2,model_influce_from_p_p_s.k.3,model_influce_from_p_p_s.k.4,model_influce_from_p_p_s.k.5,model_influce_from_p_p_s.d.2,model_influce_from_p_p_s.d.3,model_influce_from_p_p_s.d.4,model_influce_from_p_p_s.d.5, title="立法委員回應民意與民意佔比、政黨成員意見佔比及及所屬政黨與執政黨間席次差距關係分析", align=TRUE, type = 'html', summary=TRUE, notes="model 1,2,3,4 為第七屆研究範圍期間,model 5,6,7,8 為第九屆研究範圍期間")
```

以上分析顯示民意的多寡與強度乃至於人數並不當然能夠影響到民意代表的行為。(reports odds)這種現象也就隱含著影響立法委員的因素還有其他來源，也許包含政黨、金錢、媒體、民意傳達成效或是更有影響力的人民。

### 各種因素對民意代表投票的影響力




```r
#stargazer(model_influce_from_all_s.k.2,model_influce_from_all.d.2, title="立法委員回應民意與各因素關係分析", align=TRUE, type = 'html', summary=TRUE, notes="model 1 為第七屆研究範圍期間,model 2 為第九屆研究範圍期間")
```

### 政治資本與政治參與對於民意代表是否回應的中介效果

中介變項檢驗方法mediational effects
http://data.library.virginia.edu/introduction-to-mediation-analysis/
https://www.jstatsoft.org/article/view/v059i05
檢測
https://gist.github.com/stephlocke/fb1225f6b5029a9f5b04aa6e6123cbc9

## 探索性資料分析


```r
(ggplot(glmdata,
       aes(x = success_on_bill,
           y = (myown_eduyr)
           )
       ) + labs(title = "受教育年") + facet_grid(term ~ issue_field1) + geom_boxplot()) 
```

```
## Warning: Removed 30364 rows containing non-finite values (stat_boxplot).
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = success_on_bill,
           y = (myown_ses)
           )
       ) + labs(title = "職業社經地位") + facet_grid(term ~ issue_field1) + geom_boxplot()) 
```

```
## Warning: Removed 57590 rows containing non-finite values (stat_boxplot).
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-2.png)<!-- -->

```r
#(ggplot(glmdata,
#       aes(x = success_on_bill,
#           y = (myown_factoredclass)
#           )
#       ) + labs(title = "綜合社經地位") + facet_grid(term ~ .) #+ geom_boxplot()) 

(ggplot(glmdata,
       aes(x = myown_family_income_ingroup,
           fill = (success_on_bill)
       )
) + labs(title = "家庭收入所屬組別") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-3.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = success_on_bill,
           y = (myown_family_income)
           )
       ) + labs(title = "家庭收入") + facet_grid(term ~ issue_field1) + geom_boxplot()) 
```

```
## Warning: Removed 125730 rows containing non-finite values (stat_boxplot).
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-4.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = success_on_bill,
           y = (myown_family_income_stdev)
           )
       ) + labs(title = "家庭收入多少標準差") + facet_grid(term ~ issue_field1) + geom_boxplot()) 
```

```
## Warning: Removed 125730 rows containing non-finite values (stat_boxplot).
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-5.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_dad_ethgroup,
           fill = (success_on_bill)
       )
) + labs(title = "父親族群") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-6.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_mom_ethgroup,
           fill = (success_on_bill)
       )
) + labs(title = "母親族群") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-7.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_selfid,
           fill = (success_on_bill)
       )
) + labs(title = "自我族群") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-8.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_approach_to_politician_or_petition,
           fill = (success_on_bill)
       )
) + labs(title = "有無請願或找政治人物") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-9.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_protest,
           fill = (success_on_bill)
       )
) + labs(title = "有無抗議") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-10.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_vote,
           fill = (success_on_bill)
       )
) + labs(title = "有無投票") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-11.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_selfid,
           fill = (myown_approach_to_politician_or_petition)
       )
) + labs(title = "各個族群的有無請願或找政治人物") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-12.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_selfid,
           fill = (myown_protest)
       )
) + labs(title = "各個族群的有無抗議") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-13.png)<!-- -->

```r
(ggplot(glmdata,
       aes(x = myown_selfid,
           fill = (myown_vote)
       )
) + labs(title = "各個族群的有無投票") + facet_grid(term ~ issue_field1) + geom_bar(position="fill"))
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-11-14.png)<!-- -->

## 其他模型：隨機森林

https://github.com/thomasp85/lime

## 其他模型：決策樹


```r
require(rpart)
require(rpart.plot)
set.seed(22)
train.index <- sample(x=1:nrow(glmdata),
                      size=ceiling(0.8*nrow(glmdata) ))
train <- glmdata[train.index,1:73]
test <- glmdata[-train.index,1:73]
cart.model<- rpart(success_on_bill ~ opinion_pressure_from_constituent_by_nation+same_pos_to_all_ratio_by_electionarea+myown_family_income+myown_ses+myown_vote+myown_protest+myown_approach_to_politician_or_petition+myown_eduyr+myown_selfid+myown_selfid_population+myown_sex+myown_dad_ethgroup+myown_mom_ethgroup, 
                   data=train)
rattle::fancyRpartPlot(cart.model, cex=1.1,sub="")
```

![](E:\Software\scripts\R\vote_record\analysis_result_on_bill_passed_files/figure-html/unnamed-chunk-12-1.png)<!-- -->






binary logistic



myown_pol_efficacy
myown_approach_to_politician_or_petition
myown_protest

myown_working_status
total_votes_from_same_party
same_votes_from_same_party
percent_of_same_votes_from_same_party
vote_along_with_majority_in_party
issue_field1
opiniondirectionfromconstituent
opiniondirectionfrombill
opiniondirectionfromlegislator
respondopinion
same_opiniondirection_from_constituent_by_nation
all_opiniondirection_from_constituent_by_nation
opinion_pressure_from_constituent_by_nation



When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:



## Including Plots

You can also embed plots, for example:


```r
getwd()
```

```
## [1] "E:/Software/scripts/R/vote_record"
```

## sessionInfo()


```
## R version 3.4.4 (2018-03-15)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=Chinese (Traditional)_Taiwan.950 
## [2] LC_CTYPE=Chinese (Traditional)_Taiwan.950   
## [3] LC_MONETARY=Chinese (Traditional)_Taiwan.950
## [4] LC_NUMERIC=C                                
## [5] LC_TIME=Chinese (Traditional)_Taiwan.950    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] rpart.plot_2.1.2 rpart_4.1-13     ggplot2_2.2.1    stargazer_5.2.1 
##  [5] rmarkdown_1.9    bindrcpp_0.2.2   openxlsx_4.0.17  magrittr_1.5    
##  [9] dplyr_0.7.4      readr_1.1.1      xml2_1.2.0       XML_3.98-1.10   
## [13] stringi_1.1.7   
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.16       RColorBrewer_1.1-2 pillar_1.2.1      
##  [4] compiler_3.4.4     plyr_1.8.4         bindr_0.1.1       
##  [7] tools_3.4.4        digest_0.6.15      evaluate_0.10.1   
## [10] tibble_1.4.2       gtable_0.2.0       pkgconfig_2.0.1   
## [13] rlang_0.2.0        yaml_2.1.18        RGtk2_2.20.34     
## [16] stringr_1.3.0      knitr_1.20         hms_0.4.2         
## [19] rprojroot_1.3-2    grid_3.4.4         glue_1.2.0        
## [22] R6_2.2.2           reshape2_1.4.3     backports_1.1.2   
## [25] scales_0.5.0       htmltools_0.3.6    assertthat_0.2.0  
## [28] rattle_5.1.0       colorspace_1.3-2   labeling_0.3      
## [31] lazyeval_0.2.1     munsell_0.4.3
```
