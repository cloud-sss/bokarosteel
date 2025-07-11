const express = require('express'),
  appApiRouter = express.Router(),
  dateFormat = require('dateformat'),
  bcrypt = require("bcrypt"),
  fs = require('fs'),
  upload = require('express-fileupload'),
   moment = require('moment'),
  puppeteer = require('puppeteer');

const request = require('request');

appApiRouter.use(upload());

var db_id = 1;

const { F_Select, Api_Insert, RunProcedure } = require('../controller/masterController');

appApiRouter.post('/chk_acc', async (req, res) => {
  var data = req.body;
  var phone_no = data.phone_no.split(' ').join('');
  var pax_id = db_id,
    fields = "COUNT(*) chkacc",
    table_name = "mm_member",
    where = `mobile_no = '${phone_no.length > 10 ? phone_no.slice(-10) : phone_no}'`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  // console.log(resDt.msg.CHKACC);
  if(resDt.suc > 0 && resDt.msg.CHKACC == 1){
    fields = "COUNT(*) chkacc";
    table_name = "mm_member";
    where = `mobile_no = '${phone_no.length > 10 ? phone_no.slice(-10) : phone_no}'`;
    order = null;
    flag = 0;
    let dt = await F_Select(pax_id, fields, table_name, where, order, flag)
    resDt = dt
    res.send(resDt);
  }else{
    res.send(resDt);
  }
})

appApiRouter.post('/has_acc', async (req, res) => {
  var data = req.body;
  var phone_no = data.phone_no.split(' ').join('');
  var pax_id = db_id,
    fields = "COUNT(*) HAS_ACC",
    table_name = "MD_USER",
    where = `USER_CD = '${phone_no.length > 10 ? phone_no.slice(-10) : phone_no}'`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/prof_dtls', async (req, res) => {
  var data = req.body;
  var phone_no = data.phone_no.split(' ').join('');
  var pax_id = db_id,
    // fields = "cust_cd, phone, initcap(cust_name)cust_name, email, initcap(present_address)present_address, initcap(nominee)nominee",
    fields = "member_id cust_cd,d_o_birth + 1 AS d_o_birth,mobile_no phone, initcap(member_name)cust_name,NVL(off_phone_no, '') AS email, address present_address, guardian_name nominee",
    table_name = "mm_member",
    where = `mobile_no = '${phone_no.length > 10 ? phone_no.slice(-10) : phone_no}'`,
    order = null,
    flag = 0;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)

      if (resDt.msg.length>0) {
        resDt.msg.D_O_BIRTH = resDt.msg.D_O_BIRTH
          ? moment(resDt.msg.D_O_BIRTH).format('YYYY-MM-DD')
          : null;
      }
    
  res.send(resDt);
})

appApiRouter.post('/deposit_type_list', async (req, res) => {
  var data = req.body;
  var cust_cd = data.cust_cd;
  var pax_id = db_id,
      fields = "CAST(A.ACC_TYPE_CD AS NUMBER) AS ACC_TYPE_CD, INITCAP(B.ACC_TYPE_DESC) AS ACC_TYPE_DESC, CAST(A.ACC_NUM AS NUMBER) AS ACC_NUM, CAST(A.CLR_BAL AS NUMBER) AS Balance,'D' as AC_FLAG,CAST(A.PRN_AMT AS NUMBER) as PRN_AMT",
    table_name = "TM_DEPOSIT A, MM_ACC_TYPE B",
    where = `A.CUST_CD = ${cust_cd} AND nvl(A.ACC_STATUS,'O') <> 'C' AND A.ACC_TYPE_CD = B.ACC_TYPE_CD AND A.ACC_TYPE_CD !=6  
     UNION
SELECT 
  CAST(11 AS NUMBER) AS ACC_TYPE_CD, 
  'Thrift Fund' AS ACC_TYPE_DESC, 
  CAST(11 AS NUMBER) AS ACC_NUM, 
  CAST(THRIFT_AMT AS NUMBER) AS Balance,'TF' as AC_FLAG,CAST(0 AS NUMBER) as PRN_AMT 
FROM 
  TM_THRIFT_FUND 
WHERE 
  member_id = ${cust_cd}  
  UNION  SELECT 
  CAST(11 AS NUMBER) AS ACC_TYPE_CD, 
  'Gurantee Fund' AS ACC_TYPE_DESC, 
  CAST(11 AS NUMBER) AS ACC_NUM, 
  CAST(PG_AMT AS NUMBER) AS Balance,'GF' as AC_FLAG,CAST(0 AS NUMBER) as PRN_AMT 
FROM 
  TM_PG_FUND 
WHERE 
  member_id = ${cust_cd}
  UNION  SELECT 
  CAST(11 AS NUMBER) AS ACC_TYPE_CD, 
  'Share' AS ACC_TYPE_DESC, 
  CAST(11 AS NUMBER) AS ACC_NUM, 
  CAST(SHARE_AMT AS NUMBER) AS Balance,'SH' as AC_FLAG,CAST(0 AS NUMBER) as PRN_AMT 
FROM 
  TM_SHARE 
WHERE 
  SHARE_SRL_NO = ${cust_cd} 
  UNION
  SELECT CAST(6 AS NUMBER) AS ACC_TYPE_CD,
  'RD' AS ACC_TYPE_DESC,
  CAST(A.ACC_NUM AS NUMBER)  AS ACC_NUM,
  CAST(0 AS NUMBER) Balance,
  'D' as AC_FLAG,
  CAST(B.INSTL_AMT AS NUMBER)* COUNT(A.ACC_NUM) as PRN_AMT
  FROM td_rd_installment A,TM_DEPOSIT B
  WHERE A.ACC_NUM = B.ACC_NUM
  AND   B.ACC_TYPE_CD = 6
  AND   A.ACC_NUM IN (SELECT ACC_NUM
                    FROM   TM_DEPOSIT
                    WHERE  ACC_TYPE_CD = 6
                    AND    CUST_CD = ${cust_cd}
                    AND    NVL(ACC_STATUS,'O') ='O')
  AND A.STATUS = 'P'
  GROUP BY A.ACC_NUM,B.INSTL_AMT`,
    order = `Order By  ACC_TYPE_DESC`,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  
  console.log(resDt);
  res.send(resDt);
})

appApiRouter.post('/deposit_tns_dtls', async (req, res) => {
  var data = req.body;
  var acc_num = data.acc_num,
    acc_type = data.acc_type,
    AC_FLAG = data.AC_FLAG,
    cust_cd = data.cust_cd;
  var pax_id = db_id;
  if(AC_FLAG == 'TF'){
    var fields = "ROWNUM as sl_no, (trans_dt+1)trans_dt, trans_cd, 'Deposit' as particulars,'TF' trans_type,PAID_AMT as amount" , 
    table_name = `TD_THRIFT_FUND`,
    where = `MEMBER_ID =${cust_cd} AND ROWNUM<=15`

  }else if(AC_FLAG == 'GF'){
      var fields = "ROWNUM as sl_no, (trans_dt+1)trans_dt, trans_cd, 'Deposit' as particulars,'GF' trans_type,PAID_AMT as amount" , 
          table_name = `TD_PG_FUND`,
          where = `MEMBER_ID =${cust_cd} AND ROWNUM<=15`

  }else if(AC_FLAG == 'SH'){
      var fields = "ROWNUM as sl_no, (PURCHASE_DT+1)trans_dt, ROWNUM as trans_cd, 'Deposit' as particulars,'SH' trans_type,SHARE_AMT as amount", 
          table_name = `TD_SHARE`,
          where = `SHARE_SRL_NO =${cust_cd} AND ROWNUM<=15`
  }else{
  var fields = acc_type != 11 ? "ROWNUM as sl_no, (trans_dt+1)trans_dt, trans_cd, initcap(particulars)particulars, trans_type,amount" : `ROWNUM as sl_no, (paid_dt+1) trans_dt,'By Collection' particulars, trans_type,paid_amt amount`, //"trans_dt,trans_cd,particulars,trans_type,amount",
    table_name = acc_type != 11 ? `(SELECT trans_dt, trans_cd, particulars, trans_type,amount FROM V_TRANS_DTLS WHERE acc_type_cd = ${acc_type} AND acc_num ='${acc_num}' ORDER BY trans_dt desc, trans_cd)` : `(SELECT paid_dt,trans_type,paid_amt FROM TM_DAILY_DEPOSIT WHERE acc_num ='${acc_num}' and trans_type = 'D' ORDER BY paid_dt desc)`,where = `ROWNUM<=15`;
     }
  
    var order = null,
    flag = 1;
    console.log(AC_FLAG);
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  console.log(resDt);
  res.send(resDt);
})

appApiRouter.post('/deposit_acc_dtls', async (req, res) => {
  var data = req.body;
  var acc_num = data.acc_num,
    acc_type = data.acc_type;
  var pax_id = db_id,
    fields = "a.cust_cd, a.oprn_instr_cd, a.constitution_cd, (a.opening_dt+1) opening_dt, a.instl_amt, a.instl_no, (a.mat_dt+1) mat_dt, a.dep_period, a.prn_amt, round(a.intt_rt,2) intt_rt, A.CLR_BAL Balance , Decode(a.lock_mode,'L','Locked','Unlocked') lock_mode",
    table_name = "TM_DEPOSIT a, MM_ACC_TYPE b",
    where = `a.acc_type_cd= b.acc_type_cd AND a.acc_type_cd=${acc_type} AND a.acc_num = '${acc_num}' AND a.renew_id = (SELECT max(renew_id) FROM tm_deposit WHERE acc_type_cd = ${acc_type} AND acc_num = '${acc_num}')`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/daily_deposit_download', async (req, res) => {
  var data = req.body;
  var acc_num = data.acc_num,
    frmdt = dateFormat(data.frm_dt, "dd/mm/yyyy"),
    todt = dateFormat(data.to_dt, "dd/mm/yyyy");
  var pax_id = db_id,
    fields = "acc_num, trans_type, paid_dt, paid_amt, balance_amt",
    table_name = "TM_DAILY_DEPOSIT",
    where = `acc_num ='${acc_num}' AND PAID_DT BETWEEN TO_DATE('${frmdt}', 'dd/mm/yyyy') AND TO_DATE('${todt}', 'dd/mm/yyyy')`,
    order = 'ORDER BY PAID_DT, TRANS_CD',
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/deposit_download_stmt', async (req, res) => {
  var data = req.body;
  var acc_num = data.acc_num,
    acc_type = data.acc_type,
    ac_flag = data.ac_flag,
    cust_cd = data.cust_cd,
    frmdt = dateFormat(data.frm_dt, "dd/mm/yyyy"),
    todt = dateFormat(data.to_dt, "dd/mm/yyyy");
    if(ac_flag == 'GF'){
      var pax_id = db_id,
          pro_query = `DECLARE v_mem_id NUMBER; St_dt DATE; en_dt DATE; BEGIN v_mem_id := ${cust_cd};st_dt := TO_DATE('${frmdt}', 'dd/mm/yyyy');en_dt := TO_DATE('${todt}', 'dd/mm/yyyy');P_MEMBER_PG_DTLS(v_mem_id => v_mem_id,st_dt => st_dt,en_dt => en_dt); END;`,
          table_name = 'tt_member_dtls_pg_fund',
          fields = `TRANS_DT,NVL(PARTICULARS,'Deposit') as PARTICULARS,AMT_PRN_DR DR_AMT,AMT_PRN_CR CR_AMT,PG_AMT+PG_INTT_AMT BALANCE`,
          where = null,
          order = null;
    }else if(ac_flag == 'TF'){
      var pax_id = db_id,
          pro_query = `DECLARE v_mem_id NUMBER; St_dt DATE; en_dt DATE; BEGIN v_mem_id := ${cust_cd};st_dt := TO_DATE('${frmdt}', 'dd/mm/yyyy');en_dt := TO_DATE('${todt}', 'dd/mm/yyyy');P_MEMBER_THRIFT_DTLS(v_mem_id => v_mem_id,st_dt => st_dt,en_dt => en_dt); END;`,
          table_name = 'tt_member_dtls_thrift_fund',
          fields = `TRANS_DT,NVL(PARTICULARS,'Deposit') as PARTICULARS,NVL(AMT_PRN_DR,'0') as DR_AMT,AMT_PRN_CR CR_AMT,THRIFT_AMT+THRIFT_INTT_AMT BALANCE`,
          where = null,
          order = null;

    }else if(ac_flag == 'SH'){
      var pax_id = db_id,
          pro_query = `DECLARE v_mem_id NUMBER; St_dt DATE; en_dt DATE; BEGIN v_mem_id := ${cust_cd};st_dt := TO_DATE('${frmdt}', 'dd/mm/yyyy');en_dt := TO_DATE('${todt}', 'dd/mm/yyyy');P_MEMBER_SHARE_DTLS(v_mem_id => v_mem_id,st_dt => st_dt,en_dt => en_dt); END;`,
          table_name = 'tt_member_dtls_share',
          fields = `TRANS_DT,NVL(PARTICULARS,'Deposit') as PARTICULARS,NVL(AMT_DR,'0') as DR_AMT,AMT_CR CR_AMT, SHARE_BAL as BALANCE`,
          where = `SHARE_BAL > 0`,
          order = null;

    } else{
      var pax_id = db_id,
      pro_query = `DECLARE AD_ACC_TYPE_CD NUMBER; AS_ACC_NUM VARCHAR2(200); ADT_FROM_DT DATE; ADT_TO_DT DATE; BEGIN AD_ACC_TYPE_CD := ${acc_type};AS_ACC_NUM := '${acc_num}';ADT_FROM_DT := TO_DATE('${frmdt}', 'dd/mm/yyyy');ADT_TO_DT := TO_DATE('${todt}', 'dd/mm/yyyy');P_ACC_STMT(AD_ACC_TYPE_CD => AD_ACC_TYPE_CD,AS_ACC_NUM => AS_ACC_NUM,ADT_FROM_DT => ADT_FROM_DT,ADT_TO_DT => ADT_TO_DT); END;`,
      table_name = 'tt_acc_stmt',
      fields = '*',
      where = null,
      order = null;
    }
   
   //console.log(ac_flag);
  var resDt = await RunProcedure(pax_id, pro_query, table_name, fields, where, order)
  res.send(resDt);
})

appApiRouter.post('/deposit_acc_joint_holder', async (req, res) => {
  var data = req.body;
  var acc_num = data.acc_num,
    acc_type = data.acc_type;
  var pax_id = db_id,
    fields = "initcap(acc_holder)acc_holder, initcap(relation)relation",
    table_name = "TD_ACCHOLDER",
    where = `acc_type_cd=${acc_type} AND acc_num = '${acc_num}'`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/deposit_acc_nomine', async (req, res) => {
  var data = req.body;
  var acc_num = data.acc_num,
    acc_type = data.acc_type,member_id = data.member_id;
  var pax_id = db_id,
    // fields = "initcap(nom_name)nom_name,phone_no, initcap(relation)relation",
    // table_name = "td_nominee",
    // where = `acc_type_cd=${acc_type} AND acc_num = '${acc_num}'`,
    // order = null,
    // flag = 1;
    fields = "initcap(nominee_name)nom_name,phone_no, initcap(relation)relation",
    table_name = "mm_member_nominee",
    where = `member_id= '${member_id}' `,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/loan_type_list', async (req, res) => {
  var data = req.body;
  var cust_cd = data.cust_cd;
  var pax_id = db_id,
    fields = " a.acc_cd, a.loan_id, a.curr_prn_amt+a.ovd_prn_amt, a.curr_intt+a.ovd_intt, initcap(b.acc_type_desc)acc_type_desc",
    table_name = "TM_LOAN_ALL a, mm_acc_type b",
    where = `a.acc_cd=b.acc_type_cd and a.member_id= ${cust_cd} and a.curr_prn_amt+a.ovd_prn_amt>0`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/loan_tns_dtls', async (req, res) => {
  var data = req.body;
  var loan_id = data.loan_id;
  var pax_id = db_id,
    // fields = `ROWNUM as sl_no,trans_dt,trans_cd, 'R' as trans_flag,  decode(trans_type,'B','Disbursement', 'I', 'Interest', 'R','Recovery', 'O','Overdue') trans_type, disb_amt, prn_recov, intt_recov, intt_calc, PRN_TRF`,
     fields = `trans_dt,trans_cd, 'R' as trans_flag, 'Recovery' as trans_type, 0 as disb_amt, curr_prn_recov+ovd_prn_recov prn_recov, curr_intt_recov+ovd_intt_recov intt_recov, 0 as intt_calc, 0 as PRN_TRF`,
    // table_name = `(SELECT trans_dt,trans_cd,trans_type, disb_amt, curr_prn_recov+ovd_prn_recov prn_recov, curr_intt_recov+ovd_intt_recov intt_recov, curr_intt_calculated+ovd_intt_calculated intt_calc, PRN_TRF FROM GM_LOAN_TRANS WHERE loan_id ='${loan_id}' ORDER BY trans_dt desc,trans_cd)`,//"GM_LOAN_TRANS",
    table_name =`TM_RECOV_ALL`
    //where = 'ROWNUM<=15',//`loan_id ='${loan_id}'`,
    where = `loan_id ='${loan_id}'`,
    order = null,//'ORDER BY trans_dt DESC, trans_cd',
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/loan_acc_dtls', async (req, res) => {
  var data = req.body;
  var loan_id = data.loan_id,
    acc_cd = data.acc_cd;
  var pax_id = db_id,
    // fields = "a.ACC_CD,initcap(b.acc_type_desc)acc_type_desc,a.LOAN_ID,a.PARTY_CD,c.MEMBER_NAME CUST_NAME,a.SANC_DT DISB_DT,a.SANC_AMT DISB_AMT,a.CURR_RT CURR_INTT_RATE,A.OVD_RT,a.INSTL_NO,'' PIRIODICITY,'' INSTL_START_DT,a.curr_prn,a.ovd_prn,a.curr_intt,a.ovd_intt,a.last_intt_calc_dt",
    fields = "a.ACC_CD,initcap(b.acc_type_desc)acc_type_desc,a.LOAN_ID,a.MEMBER_ID,c.MEMBER_NAME CUST_NAME,a.SANC_DT DISB_DT,a.SANC_AMT DISB_AMT,a.CURR_INTT CURR_INTT_RATE,a.INSTL_NO,'' PIRIODICITY,'' INSTL_START_DT,a.curr_prn_amt as CURR_PRN,a.ovd_prn_amt OVD_PRN,a.curr_intt,a.ovd_intt,a.last_intt_calc_dt",
    table_name = "TM_LOAN_ALL a, MM_ACC_TYPE b, MM_MEMBER c",
    where = `a.acc_Cd= b.acc_type_cd AND a.MEMBER_ID= c.MEMBER_ID AND a.acc_cd=${acc_cd} AND a.loan_id = '${loan_id}'`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/loan_stmt_download', async (req, res) => {
  var data = req.body;
  var loan_id = data.loan_id,
    frmdt = dateFormat(data.frm_dt, "dd-mmm-yy"),
    todt = dateFormat(data.to_dt, "dd-mmm-yy");
  var pax_id = db_id,
    // fields = "trans_dt, trans_cd, trans_type trans_flag, decode(trans_type,'B','Disbursement', 'I', 'Interest', 'R','Recovery', 'O','Overdue') trans_type, disb_amt, curr_prn_recov+ovd_prn_recov prn_recov, curr_intt_recov+ovd_intt_recov intt_recov, curr_intt_calculated+ovd_intt_calculated intt_calc, PRN_TRF, curr_prn, ovd_prn, curr_intt, ovd_intt, last_intt_calc_dt, curr_prn_recov, curr_intt_recov, ovd_prn_recov, ovd_intt_recov",

     fields = `a.trans_dt,a.trans_cd, 'R' as trans_flag, 'Recovery' as trans_type, 0 as disb_amt, b.curr_prn_recov+b.ovd_prn_recov prn_recov, b.curr_intt_recov+ b.ovd_intt_recov intt_recov, a.curr_intt+a.ovd_intt as intt_calc, 0 as PRN_TRF,a.curr_prn_amt curr_prn,a.ovd_prn_amt ovd_prn, a.curr_intt, a.ovd_intt, a.last_intt_calc_dt, b.curr_prn_recov, b.curr_intt_recov, b.ovd_prn_recov, b.ovd_intt_recov`,
    table_name = "tm_loan_all a, tm_recov_all b",
    where = `a.loan_id = b.loan_id AND a.loan_id ='${loan_id}' AND a.trans_dt BETWEEN '${frmdt}' AND '${todt}'`,
    order = 'ORDER BY a.trans_dt, a.trans_cd',
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/save_user', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var pass = bcrypt.hashSync(data.pin, 10);
  var user_id = data.user_id.split(' ').join('')
  user_id = user_id.length > 10 ? user_id.slice(-10) : user_id
  var pax_id = db_id,
    table_name = 'MD_USER',
    fields = "USER_CD, MPIN, USER_NAME, CUST_CD, LAST_LOGIN, ACTIVE_STATUS, CREATED_BY, CREATED_DT",
    fieldIndex = `(:0, :1, :2, :3, :4, :5, :6, :7)`,
    values = [user_id, pass, data.userName, data.custCd, datetime, 'A', data.user_id, dateFormat(datetime, "dd-mmm-yy")],
    where = null,
    flag = 0;
  var resDt = await Api_Insert(pax_id, table_name, fields, fieldIndex, values, where, flag)
  res.send(resDt);
})

appApiRouter.post("/login", async (req, res) => {
  var data = req.body;
  var userId = data.phone_no.split(' ').join('');
  userId = userId.length > 10 ? userId.slice(-10) : userId
  var chkuser = await chkUserPlayFlag(userId);
  // console.log({chk: chkuser.msg.CHKACC});
  if(chkuser.suc > 0 && chkuser.msg.CHKACC > 0 || userId == '9007507220' || userId == '9831887194' || userId == '9748767314'){
  var pax_id = db_id,
    fields = `user_cd, mpin, last_login, active_status, initcap(user_name)user_name, cust_cd, img_path, 'BSECCS' BANK_NAME, bank_id, 'A' VIEW_FLAG`,
    table_name = "md_user",
    where = `user_cd ='${userId}'`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
  // console.log(resDt.msg["MPIN"], data.pin);
  // console.log(await bcrypt.compare(data.pin, resDt.msg["MPIN"]));
  var res_dt;
  if (resDt.suc > 0) {
    if (await bcrypt.compare(data.pin, resDt.msg["MPIN"])) {
      // await updateUserLogin(userId);
      res_dt = { suc: 1, msg: resDt.msg };
    } else {
      res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
    }
  } else {
    res_dt = resDt;
  }
}else{
  res_dt = { suc: 0, msg: "Your account is deactivated. Please contact with bank." };
}
  res.send(res_dt);
});

const chkUserPlayFlag = (phone_no) => {
  return new Promise(async (resolve, reject) => {
    var pax_id = db_id,
    fields = "COUNT(*) chkacc",
    table_name = "MM_MEMBER",
    // where = `phone = '${phone_no}' AND APP_FLAG ='Y'`,
    where = `mobile_no = '${phone_no}'`,
    order = null,
    flag = 0;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
    resolve(resDt);
  })
}

appApiRouter.post("/update_login_time", async (req, res) => {
  var data = req.body;
  var user_id = data.phone_no.split(' ').join('')
  user_id = user_id.length > 10 ? user_id.slice(-10) : user_id
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  // return new Promise(async (resolve, reject) => {
  var pax_id = db_id,
    table_name = "MD_USER",
    fields = `LAST_LOGIN = :0, MODIFIED_BY = :1, MODIFIED_DT = :2`,
    fieldIndex = null,
    values = [datetime, user_id, dateFormat(datetime, "dd-mmm-yy")],
    where = `USER_CD = '${user_id}'`,
    flag = 1;
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  res.send(resDt);
  //   resolve(resDt);
  // })
})

const chkUser = (user_id) => {
  return new Promise(async (resolve, reject) => {
    var pax_id = db_id,
      fields = "user_cd, mpin",
      table_name = "md_user",
      where = `user_cd ='${user_id.split(' ').join('')}'`,
      order = null,
      flag = 0;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    resolve(resDt);
  })
}

appApiRouter.post("/reset_pin", async (req, res) => {
  var data = req.body;
  var phone_no = data.phone_no.split(' ').join(''),
    pin = data.pin,
    oldPin = data.old_pin;
    phone_no = phone_no.length > 10 ? phone_no.slice(-10) : phone_no
  var pass = bcrypt.hashSync(pin, 10);
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");

  console.log('UserDetails', pin, oldPin, phone_no);
  console.log('Pass', pass);
  var chk_user = await chkUser(phone_no);
  var res_dt;
  if (chk_user.suc > 0) {
    if (await bcrypt.compare(oldPin, chk_user.msg["MPIN"])) {
      var pax_id = db_id,
        table_name = "MD_USER",
        fields = `MPIN = :0, MODIFIED_BY = :1, MODIFIED_DT = :2`,
        fieldIndex = null,
        values = [pass, phone_no, dateFormat(datetime, "dd-mmm-yy")],
        where = `USER_CD = '${phone_no}'`,
        flag = 1;
      var resDt = await Api_Insert(
        pax_id,
        table_name,
        fields,
        fieldIndex,
        values,
        where,
        flag
      );
      res_dt = resDt;
      res.send(res_dt);
    } else {
      res_dt = { suc: 0, msg: "Please Enter Your Correct old mPIN" };
      res.send(res_dt);
    }
  } else {
    res_dt = chk_user;
    res.send(res_dt);
  }
})
appApiRouter.post("/set_pin", async (req, res) => {
  var data = req.body;
  var phone_no = data.phone_no.split(' ').join(''),
    pin = data.pin,
    phone_no = phone_no.length > 10 ? phone_no.slice(-10) : phone_no
  var pass = bcrypt.hashSync(pin, 10);
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");

  console.log('UserDetails', pin, phone_no);
  console.log('Pass', pass);
  var chk_user = await chkUser(phone_no);
  var res_dt;
  if (chk_user.suc > 0) {
   // if (await bcrypt.compare(oldPin, chk_user.msg["MPIN"])) {
      var pax_id = db_id,
        table_name = "MD_USER",
        fields = `MPIN = :0, MODIFIED_BY = :1, MODIFIED_DT = :2`,
        fieldIndex = null,
        values = [pass, phone_no, dateFormat(datetime, "dd-mmm-yy")],
        where = `USER_CD = '${phone_no}'`,
        flag = 1;
      var resDt = await Api_Insert(
        pax_id,
        table_name,
        fields,
        fieldIndex,
        values,
        where,
        flag
      );
      res_dt = resDt;
      res.send(res_dt);
  //  } else {
   //   res_dt = { suc: 0, msg: "Please Enter Your Correct old mPIN" };
   //   res.send(res_dt);
   // }
  } else {
    res_dt = chk_user;
    res.send(res_dt);
  }
})

appApiRouter.post("/send_otp", async (req, res) => {
  var data = req.body;
  var to = data.phone_no.split(' ').join('');
  to = to.length > 10 ? to.slice(-10) : to
  var otp = Math.floor(1000 + Math.random() * 9000);
	
  // var text = `OTP for mobile verification is ${otp}. This code is valid for 5 minutes. Please do not share this OTP with anyone. -BOKARO STEEL officers co op society Ltd.`;
  var text = `OTP for mobile verification is ${otp}. This code is valid for 10 minutes. Please do not share this OTP with anyone. -Bokaro Steel ECCS.`;
  
  console.log('BSECCS OTP: ', to, otp);
  //res.send({ suc: 1, msg: 'Otp Sent', otp })
    var options = {
      'method': 'GET',
      'url': `http://sms.synergicapi.in/api.php?username=BOKAROSTEEL&apikey=vboAoAq7D3JT&senderid=BSTECS&route=OTP&mobile=${to.split(' ').join('')}&text=${text}`,
      'headers': {
      }
    };
  
  request(options, function (error, response) {
    if (error) {
      console.log(err);
      res.send({ suc: 0, msg: 'Otp Not Sent', otp })
    }
    else {
      console.log('OTP Console', response.body, otp);
      res.send({ suc: 1, msg: 'Otp Sent', otp })
    }
  });
})

appApiRouter.get('/cal_details', async (req, res) => {
  var pax_id = db_id,
    fields = "sl_no, cal_dt, cal_event",
    table_name = "td_calendar",
    where = null,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/update_profile', async (req, res) => {
  var files = req.files ? (req.files.picture ? req.files.picture : null) : null,
    file_name = '',
    file_path = '',
    user_id = req.body.user_id;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var resDt;

  if (files) {
    file_name = files.name;
    file_name = file_name.split(' ').join('_');
    path = `assets/uploads/${file_name}`;
    file_path = `uploads/${file_name}`;
    files.mv(path, async (err) => {
      if (err) {
        console.log(`${file_name} not uploaded`);
      } else {
        console.log(`Successfully ${file_name} uploaded`);
        var pax_id = db_id,
          table_name = "MD_USER",
          fields = `IMG_PATH = :0, MODIFIED_BY = :1, MODIFIED_DT = :2`,
          fieldIndex = null,
          values = [file_path, user_id, dateFormat(datetime, "dd-mmm-yy")],
          where = `USER_CD = '${user_id}'`,
          flag = 1;
        resDt = await Api_Insert(
          pax_id,
          table_name,
          fields,
          fieldIndex,
          values,
          where,
          flag
        );
        res.send(resDt);
        // await SectionImageSave(data, filename);
      }
    })
  } else {
    resDt = {suc: 0, msg: 'File Not Selected'}
    res.send(resDt)
    // file_name = '';
  }
})

appApiRouter.post('/request_passbook_acc_list', async (req, res) => {
  var cust_id = req.body.cust_id;
  var pax_id = db_id,
      fields = "A.ACC_TYPE_CD,initcap(B.ACC_TYPE_DESC)ACC_TYPE_DESC,A.ACC_NUM",
      table_name = "TM_DEPOSIT A, MM_ACC_TYPE B",
      where = `A.CUST_CD = ${cust_id.split(' ').join('')} AND   nvl(A.ACC_STATUS,'O') <> 'C' AND   A.ACC_TYPE_CD= B.ACC_TYPE_CD AND   a.acc_type_cd IN (1,7,6)`,
      order = null,
      flag = 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    res.send(resDt);
})

appApiRouter.post('/request_cheque_acc_list', async (req, res) => {
  var cust_id = req.body.cust_id;
  var pax_id = db_id,
      fields = "A.ACC_TYPE_CD,  initcap(B.ACC_TYPE_DESC)ACC_TYPE_DESC, A.ACC_NUM" +
                " FROM  TM_DEPOSIT A, MM_ACC_TYPE B" +
                " WHERE A.CUST_CD = " + cust_id.split(' ').join('') +
                " AND   nvl(A.ACC_STATUS,'O') <> 'C'" +
                " AND   A.ACC_TYPE_CD= B.ACC_TYPE_CD" +
                " AND   a.acc_type_cd IN (1,7)" +
                " AND   a.cheque_facility_flag = 'Y'" +
                " UNION" +
                " SELECT A.ACC_CD ACC_TYPE_CD, initcap(B.ACC_TYPE_DESC)ACC_TYPE_DESC, A.LOAN_ID ACC_NUM" +
                " FROM  TM_LOAN_ALL A, MM_ACC_TYPE B" +
                " WHERE A.PARTY_CD = " + cust_id.split(' ').join('') +
                " AND   A.ACC_CD= B.ACC_TYPE_CD" +
                " AND   a.acc_cd = 23115" +
                " AND   a.cheque_facility = 'Y'",
      table_name = null,
      where = null,
      order = null,
      flag = 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    res.send(resDt);
})

appApiRouter.post('/request_statement_acc_list', async (req, res) => {
  var cust_id = req.body.cust_id;
  var pax_id = db_id,
      fields = "A.ACC_TYPE_CD,  initcap(B.ACC_TYPE_DESC)ACC_TYPE_DESC, A.ACC_NUM" +
      " FROM  TM_DEPOSIT A, MM_ACC_TYPE B" +
      " WHERE A.CUST_CD = " + cust_id.split(' ').join('') + " AND nvl(A.ACC_STATUS,'O') <> 'C'" +
      " AND   A.ACC_TYPE_CD= B.ACC_TYPE_CD" +
      " UNION"+
      " SELECT A.ACC_CD ACC_TYPE_CD, initcap(B.ACC_TYPE_DESC)ACC_TYPE_DESC, A.LOAN_ID ACC_NUM" +
      " FROM  TM_LOAN_ALL A, MM_ACC_TYPE B" +
      " WHERE A.PARTY_CD = " + cust_id.split(' ').join('') +
      " AND   A.ACC_CD= B.ACC_TYPE_CD",
      table_name = null,
      where = null,
      order = null,
      flag = 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    res.send(resDt);
})

appApiRouter.post('/send_request', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var pax_id = db_id,
    table_name = "TD_REQUEST",
    fields = `SL_NO, REQ_DT, REQ_CUST_ID, ACC_TYPE_ID, ACC_TYPE_NAME, ACC_NO, REQ_FLAG ${data.flag == 'A' ? ', FRM_DT, TO_DT' : ''}`,
    fieldIndex = `((SELECT Nvl(MAX(SL_NO),0)+1 FROM TD_REQUEST), :0, :1, :2, :3, :4, :5 ${data.flag == 'A' ? ', :6, :7' : ''})`,
    values,
    where = null,
    flag = 0;
    if(data.flag != 'A'){
      values = [
        dateFormat(datetime, "dd-mmm-yy"),
        data.cust_id,
        data.acc_type_id,
        data.acc_tyep_name,
        data.acc_no,
        data.flag,
      ];
    }else{
      values = [
        dateFormat(datetime, "dd-mmm-yy"),
        data.cust_id,
        data.acc_type_id,
        data.acc_tyep_name,
        data.acc_no,
        data.flag,
        dateFormat(data.frm_dt, "dd-mmm-yy"),
        dateFormat(data.to_dt, "dd-mmm-yy"),
      ];
    }
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  res.send(resDt);
})

appApiRouter.post('/get_request', async (req, res) => {
  var data = req.body;
  var pax_id = db_id,
    fields = "*",
    table_name = `( SELECT SL_NO, REQ_DT, REQ_FLAG, FRM_DT, TO_DT, UPDATE_FLAG, REMARKS FROM TD_REQUEST WHERE REQ_CUST_ID = '${data.cust_id}' AND ACC_TYPE_ID = '${data.acc_type_id}' AND ACC_NO = '${data.acc_no}' AND REQ_FLAG = '${data.flag}' ORDER BY SL_NO DESC)`,
    where = `ROWNUM<=1`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/td_emi_calculator', async (req, res) => {
  var data = req.body;
  var pax_id = db_id,
    fields = `F_CALCTDINTT_REG1(${data.acc_type},${data.prn_amt},TO_DATE('${dateFormat(data.sys_dt, 'dd/mm/yyyy')}', 'dd/mm/yyyy'),'${data.intt_type}',${data.period},${data.intt_rate}) res`,
    table_name = `DUAL`,
    where = null,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/rd_emi_calculator', async (req, res) => {
  var data = req.body;
  var pax_id = db_id,
    fields = `F_CALCRDINTT_REG1(6,${data.instl_amt},${data.period},${data.inst_rate}) res`,
    table_name = `DUAL`,
    where = null,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})
appApiRouter.post('/loan_emi_calculator', async (req, res) => {
  
		 var data = req.body;
		  var prn_amt = data.prn_amt,
     intt_rate = data.intt_rate,
	  period = data.period,
	  intt_type = data.intt_type;
	 var pax_id = 2;
		var	pro_query = `DECLARE LD_PRN_AMT NUMBER; LD_INTT_RT NUMBER; LD_NO_INSTL NUMBER; LD_EMI_FORMULA NUMBER; BEGIN LD_PRN_AMT := ${prn_amt};LD_INTT_RT := '${intt_rate}';LD_NO_INSTL := '${period}';LD_EMI_FORMULA := '${intt_type}';P_EMI_DISPLAY(LD_PRN_AMT => LD_PRN_AMT,LD_INTT_RT => LD_INTT_RT,LD_NO_INSTL => LD_NO_INSTL,LD_EMI_FORMULA => LD_EMI_FORMULA); END;`;
		var	table_name = 'TT_EMI_DISPLAY',
			fields = 'EMI_NO,ROUND(EMI_PRN) as EMI_PRN,ROUND(EMI_INTT) as EMI_INTT,ROUND(TOTAL_EMI) as TOTAL_EMI',
			where = null,
			order = null;
	
	   console.log(pro_query);
	 var resDt = await RunProcedure(pax_id, pro_query, table_name, fields, where, order);
     res.send({ suc: 1, msg: resDt  });
})

appApiRouter.post('/feedback', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var pax_id = db_id,
    table_name = "TD_FEEDBACK",
    fields = `SL_NO, RATING, REMARKS, CREATED_BY, CREATED_AT`,
    fieldIndex = `((SELECT Nvl(MAX(SL_NO),0)+1 FROM TD_FEEDBACK), :0, :1, :2, :3)`,
    values = [
      data.rating,
      data.remarks,
      data.user_id,
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = null,
    flag = 0;
    
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  res.send(resDt);
})

appApiRouter.post('/transaction_upload', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "TRNS_ID, TRNS_DT, CHQ_NO, CHQ_DT, BANK_NAME, ENTRY_DT, CUST_ID, TRNS_AMT",
    table_name = `td_transaction_upload`,
    where = data.trns_id > 0 ? `TRNS_ID = '${data.trns_id}' ${data.cust_id > 0 ? `AND CUST_ID = ${data.cust_id}`: ''}` : (data.cust_id > 0 ? `CUST_ID = ${data.cust_id}`: null),
    order = 'ORDER BY trns_dt DESC',
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/transaction_upload_save', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var pax_id = db_id,
    table_name = "td_transaction_upload",
    fields = data.id > 0 ? `TRNS_DT = :0, CHQ_NO = :1, CHQ_DT = :2, BANK_NAME = :3, CUST_ID = :4, TRNS_AMT = :5, MODIFIED_BY = :6, MODIFIED_DT = :7` : `TRNS_ID, TRNS_DT, CHQ_NO, CHQ_DT, BANK_NAME, CUST_ID, TRNS_AMT, CREATED_BY, CREATED_DT, ENTRY_DT`,
    fieldIndex = `(:0, :1, :2, :3, :4, :5, :6, :7, :8, :9)`,
    values = data.id > 0 ? [
      dateFormat(data.trns_dt, "dd-mmm-yy"),
      data.chq_no,
      dateFormat(data.chq_dt, "dd-mmm-yy"),
      data.bank_name,
      data.cust_id,
      data.trns_amt,
      data.user,
      dateFormat(datetime, "dd-mmm-yy"),
    ] : [
      data.trns_id,
      dateFormat(data.trns_dt, "dd-mmm-yy"),
      data.chq_no,
      dateFormat(data.chq_dt, "dd-mmm-yy"),
      data.bank_name,
      data.cust_id,
      data.trns_amt,
      data.user,
      dateFormat(datetime, "dd-mmm-yy"),
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = data.id > 0 ? `trns_id = '${data.trns_id}'` : null,
    flag = data.id > 0 ? 1 : 0;
    
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  res.send(resDt);
})

appApiRouter.post('/get_branch_list', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `md_branch`,
    where = `bank_id=${data.bank_id}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_demand_dtls', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    // fields = "a.member_id, a.member_name, a.month, a.year, a.acc_type_cd, b.acc_type_desc, a.acc_num, a.prn_amt, a.intt_amt",
    // table_name = `tm_demand_view a, mm_acc_type b`,
    // where = `a.acc_type_cd=b.acc_type_cd and a.member_id = ${data.memb_id}
    // and a.month = (select max(c.month) from tm_demand_view c where c.member_id = a.member_id and c.year = (select MAX(d.year) from tm_demand_view d where d.member_id=a.member_id))
    // and a.year = (select MAX(d.year) from tm_demand_view d where d.member_id=a.member_id)
    // and (a.prn_amt > 0 or a.intt_amt > 0)`,
    // order = 'order by a.acc_type_cd',

    fields = "a.member_id, '' member_name, a.month, a.year,'' acc_type_cd, 'Loan' acc_type_desc, '' acc_num, (loan_amt_emg + loan_amt_mid + loan_amt_long+loan_amt_slt+loan_amt_utility+loan_amt_hb+loan_amt_festival+loan_amt_lad+loan_amt_edu+loan_amt_gift) prn_amt ,(loan_emg_intt+loan_mid_intt+loan_long_intt+loan_slt_intt+loan_utility_intt+loan_hb_intt+loan_festival_intt+loan_lad_intt+loan_medical_intt+loan_las_intt+loan_edu_intt+loan_gift_intt) intt_amt,thrift_contribution,welfare_amt,savings_amt",
    table_name = `tm_demand_actual a`,
    where = `a.member_id = ${data.memb_id}
    and a.month = (select max(c.month) from tm_demand_actual c where c.member_id = a.member_id and c.year = (select MAX(d.year) from tm_demand_actual d where d.member_id=a.member_id))
    and a.year = (select MAX(d.year) from tm_demand_actual d where d.member_id=a.member_id)`,
    order = null,

    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_memb_application', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `td_memb_application`,
    where = `member_id=${data.member_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/memb_application_save', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");

  var pax_id = db_id,
    fields = "NVL(MAX(SL_NO), 0) + 1 as last_id",
    table_name = `td_memb_application`,
    where = null,
    order = null,
    flag = 1;
  var last_id = await F_Select(pax_id, fields, table_name, where, order, flag)

  var pax_id = db_id,
    table_name = "td_memb_application",
    fields = data.sl_no > 0 ? `MEM_NAME = :3, DOB = :4, CO_NAME = :5, ISSUED_BY = :6, MEMO_NO = :7, MEMO_DT = :8, TOT_SHARE = :9, NOMI_NAME = :10, NOMI_RELATION = :11, NOMI_ADDR = :12, NOMI_AGE = :13, OFFICE_NAME = :14, DESIGNATION = :15, DEP_ENTRY_DT = :16, MON_SUB_PAY = :17, LAST_INC_DT = :18, PER_ADDR = :19, LOCAL_ADDR = :20, MODIFIED_BY = :21, MODIFIED_DT = :22` : `SL_NO, MEMBER_ID, ENTRY_DT, RECEIPT_DT, MEM_NAME, DOB, CO_NAME, ISSUED_BY, MEMO_NO, MEMO_DT, TOT_SHARE, NOMI_NAME, NOMI_RELATION, NOMI_ADDR, NOMI_AGE, OFFICE_NAME, DESIGNATION, DEP_ENTRY_DT, MON_SUB_PAY, LAST_INC_DT, PER_ADDR, LOCAL_ADDR, CREATED_BY, CREATED_DT`,
    fieldIndex = `((SELECT NVL(MAX(SL_NO), 0) + 1 FROM td_memb_application), :0, :1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21, :22)`,
    values = [
      data.memb_id,
      dateFormat(datetime, "dd-mmm-yy"),
      data.receipt_dt ? dateFormat(data.receipt_dt, "dd-mmm-yy") : null,
      data.memb_name,
      data.dob ? dateFormat(data.dob, "dd-mmm-yy") : null,
      data.co_name,
      data.issue_by,
      data.memo_no,
      data.memo_dt ? dateFormat(data.memo_dt, "dd-mmm-yy") : null,
      data.tot_share,
      data.nomi_name,
      data.nomi_rel,
      data.nomi_addr,
      data.nomi_age,
      data.offfice_name,
      data.designation,
      data.dep_entry_dt ? dateFormat(data.dep_entry_dt, "dd-mmm-yy") : null,
      data.mon_sub_pay,
      data.last_inc_dt ? dateFormat(data.last_inc_dt, "dd-mmm-yy") : null,
      data.per_addr,
      data.loc_addr,
      data.user,
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = data.sl_no > 0 ? `sl_no = '${data.sl_no}'` : null,
    flag = data.sl_no > 0 ? 1 : 0;
    
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );

  var sl_no = data.sl_no > 0 ? data.sl_no : resDt

  res.send(resDt);
})

appApiRouter.post('/get_add_share_application', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `TD_ADD_SHARE_APPLICATION`,
    where = `member_id=${data.member_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/add_share_application_save', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var pax_id = db_id,
    table_name = "TD_ADD_SHARE_APPLICATION",
    fields = data.sl_no > 0 ? `MEM_NAME = :3, STOCK_HOLD = :4, STOCK_ALLOT = :5, MEMBERSHIP_NUMBER = :6, NOMI_NAME = :7, NOMI_RELATION = :8, ADDR = :9, OFFICE_NAME = :10, DESIGNATION = :11, MODIFIED_BY = :12, MODIFIED_DT = :13` : `SL_NO, MEMBER_ID, ENTRY_DT, RECEIPT_DATE, MEM_NAME, STOCK_HOLD, STOCK_ALLOT, MEMBERSHIP_NUMBER, NOMI_NAME, NOMI_RELATION, ADDR, OFFICE_NAME, DESIGNATION, CREATED_BY, CREATED_DT`,
    fieldIndex = `((SELECT NVL(MAX(SL_NO), 0) + 1 FROM TD_ADD_SHARE_APPLICATION), :0, :1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13)`,
    values = [
      data.memb_id,
      dateFormat(datetime, "dd-mmm-yy"),
      data.receipt_dt ? dateFormat(data.receipt_dt, "dd-mmm-yy") : null,
      data.memb_name,
      data.tot_share_hold,
      data.tot_share_allot,
      data.membership_no,
      data.nomi_name,
      data.nomi_rel,
      data.nomi_addr,
      data.offfice_name,
      data.designation,
      data.user,
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = data.id > 0 ? `sl_no = '${data.sl_no}'` : null,
    flag = data.id > 0 ? 1 : 0;
    
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  res.send({suc: resDt.suc, msg: resDt.suc > 0 ? resDt.msg : 'Data not inserted.'});
})

appApiRouter.post('/get_loan_application', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `TD_GEN_LOAN_APPLICATION`,
    where = `member_id=${data.member_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/add_loan_application_save', async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
  var pax_id = db_id,
    table_name = "TD_GEN_LOAN_APPLICATION",
    fields = data.sl_no > 0 ? `MEM_NAME = :3, MEMBERSHIP_NUMBER = :4, DOB = :5, MOBILE_NO = :6, SHARE_VALUE = :7, BASIC_PAY = :8, LAST_LOAN_AMT = :9, OLD_GEN_LOAN_BAL = :10, DEFAULTER = :11, RECOV_BNG_ASU = :12, LAST_INC_DT = :13, RATE_OF_INC = :14, NATURE_OF_SURITY = :15, PER_ADDR = :16, LOCAL_ADDR = :17, OFFICE_NAME = :18, DESIGNATION = :19, SAL_BILL_NO = :20, PART = :21, DEPT = :22, APPLY_LOAN_AMT = :23, REPAID_DT = :24, PURPOSE = :25, MODIFIED_BY = :26, MODIFIED_DT = :27` : `SL_NO, MEMBER_ID, ENTRY_DT, RECEIPT_DATE, MEM_NAME, MEMBERSHIP_NUMBER, DOB, MOBILE_NO, SHARE_VALUE, BASIC_PAY, LAST_LOAN_AMT, OLD_GEN_LOAN_BAL, DEFAULTER, RECOV_BNG_ASU, LAST_INC_DT, RATE_OF_INC, NATURE_OF_SURITY, PER_ADDR, LOCAL_ADDR, OFFICE_NAME, DESIGNATION, SAL_BILL_NO, PART, DEPT, APPLY_LOAN_AMT, REPAID_DT, PURPOSE, CREATED_BY, CREATED_DT`,
    fieldIndex = `((SELECT NVL(MAX(SL_NO), 0) + 1 FROM TD_GEN_LOAN_APPLICATION), :0, :1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21, :22, :23, :24, :25, :26, :27)`,
    values = [
      data.memb_id,
      dateFormat(datetime, "dd-mmm-yy"),
      data.receipt_dt ? dateFormat(data.receipt_dt, "dd-mmm-yy") : null,
      data.mem_name,
      data.memb_number,
      data.dob ? dateFormat(data.dob, "dd-mmm-yy") : null,
      data.mobile_no,
      data.share_val,
      data.basic_pay,
      data.last_loan_amt,
      data.old_gen_loan_bal,
      data.defaulter,
      data.recov_bng_asu,
      data.last_inc_dt ? dateFormat(data.last_inc_dt, "dd-mmm-yy") : null,
      data.roi,
      data.security_nature,
      data.per_addr,
      data.local_addr,
      data.office_name,
      data.designation,
      data.sal_bil_no,
      data.part,
      data.dept,
      data.apply_loan_amt,
      data.repaid_dt ? dateFormat(data.repaid_dt, "dd-mmm-yy") : null,
      data.purpose,
      data.user,
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = data.id > 0 ? `sl_no = '${data.sl_no}'` : null,
    flag = data.id > 0 ? 1 : 0;
    
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  res.send(resDt);
})

appApiRouter.post('/get_state_of_nature_dtls', (req, res) => {
  var res_dt = [
    {'id': '', 'name': 'Select One'},
    {'id': 'P', 'name': 'Personal'},
    {'id': 'L', 'name': 'Life Policy'},
    {'id': 'S', 'name': 'Share Value'},
    {'id': 'T', 'name': 'Thrift Fund'},
    {'id': 'G', 'name': 'Personal Guarantee Fund'},
  ]

  res.send({suc: 1, msg: res_dt})
})

appApiRouter.post('/get_image_gallery', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `TD_IMG_GALLERY`,
    where = `bank_id=${data.bank_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_board_member_list', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `md_board_memb`,
    where = `bank_id=${data.bank_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_holiday_home_list', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `td_holiday_home`,
    where = `bank_id=${data.bank_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_about_dtls', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `md_about`,
    where = `bank_id=${data.bank_id} AND type = '${data.type}' ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_sec_desc', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `TD_SEC_DESK`,
    where = `bank_id=${data.bank_id} ${data.sl_no > 0 ? `AND SL_NO=${data.sl_no}` : ''}`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/get_memb_dtls', async (req, res) => {
  var data = req.body
  var pax_id = db_id,
    fields = "*",
    table_name = `MM_MEMBER`,
    where = `member_id=${data.memb_id}`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag)
  res.send(resDt);
})

appApiRouter.post('/gen_pdf', async (req, res) => {
  
  try{
    var data = req.body
    console.log(data);
    
    const browser = await puppeteer.launch({headless: 'new'});
    const page = await browser.newPage();
  
    var incFlag = Buffer.from(data.flag).toString('base64')

    // Replace with your form page URL or HTML content

    await page.goto(`${process.env.BASE_URL}/admin/application_form?flag=${incFlag}&id=${data.id}&bank_id=${data.bank_id}`, { waitUntil: 'networkidle0' });

    // Generate PDF
    const pdfBuffer = await page.pdf({ 
        format: 'A4',
        printBackground: true,
        margin: { top: "20px", bottom: "20px", left: "20px", right: "20px" }
     });

    await browser.close();

    // Define file path to save PDF on the server (optional)
    // const filePath = path.join('assets', 'uploads', 'form1.pdf');
    // require('fs').writeFileSync(filePath, pdfBuffer);

    // console.log(pdfBuffer);
    

    res.set({
        'Content-Type': 'application/pdf',
        'Content-Disposition': 'attachment; filename="form.pdf"',
        'Content-Length': pdfBuffer.length
    });

    // Send the PDF buffer as a binary response
    res.end(pdfBuffer, 'binary');
  }catch(err){
      console.log(err);
      res.send(err)
  }
})

module.exports = { appApiRouter, chkUser };