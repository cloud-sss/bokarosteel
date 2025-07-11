const { F_Select, Api_Insert, SendNotification, F_Delete } = require("../controller/masterController");
const { chkUser } = require("./appApiRouter");

const express = require("express"),
  adminRouter = express.Router(),
  dateFormat = require("dateformat"),
  bcrypt = require("bcrypt");

const request = require('request');

var db_id = 1;

adminRouter.use((req, res, next) => {
  var url = req.path;
  var user = req.session.user;
  console.log(url);
  
  if (url == "/login" || url == '/application_form' || url == '/privacy' || user) {
    next();
  } else {
    res.redirect("/admin/login");
  }
});

adminRouter.get('/', (req, res) => {
  res.redirect("/admin/login");
})

adminRouter.get("/dashboard", (req, res) => {
  //res.render("dashboard/view");
  res.redirect("/admin/calendar");
});

adminRouter.get("/login", (req, res) => {
  res.render("login/login");
});

adminRouter.post("/login", async (req, res) => {
  var data = req.body;
  var userId = data.user_id;
  var pax_id = db_id,
    fields = "user_cd, last_login, mpin, active_status, user_name, bank_id",
    table_name = "md_user",
    where = `user_cd ='${userId}' AND USER_TYPE = 'A'`,
    order = null,
    flag = 0;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
  // console.log(resDt);
  // var res_dt;
  if (resDt.suc > 0) {
    if (await bcrypt.compare(data.password, resDt.msg["MPIN"])) {
      req.session.user = resDt.msg;
      res.redirect("/admin/dashboard");
      // res_dt = { suc: 1, msg: resDt.msg };
    } else {
      // res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
      req.session.message = {
        type: "warning",
        message: "Please check your user-id or password",
      };
      res.redirect("/admin/login");
    }
  } else {
    req.session.message = {
      type: "danger",
      message: "Please check your user-id or password",
    };
    res.redirect("/admin/login");
  }
});

const calData = (id) => {
  return new Promise(async (resolve, reject) => {
    var pax_id = db_id,
      fields = "sl_no, cal_dt, cal_event",
      table_name = "td_calendar",
      where = id > 0 ? `sl_no =${id}` : "",
      order = null,
      flag = id > 0 ? 0 : 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    resolve(resDt);
  });
};

adminRouter.get("/calendar", async (req, res) => {
  var id = req.query.id > 0 ? req.query.id : null;
  var resDt = await calData(id);
  console.log(resDt);
  // if (resDt.suc > 0) {
  res.render("admin/calendar_view", {
    cal_dt: resDt,
    heading: "Calendar",
    sub_heading: "Event List",
    dateFormat,
  });
  // }
});

adminRouter.get("/calendar_edit", async (req, res) => {
  var id = req.query.id > 0 ? req.query.id : null;
  var calDt = null;
  if (id > 0) {
    var res_dt = await calData(id);
    calDt = res_dt.suc > 0 ? res_dt.msg : null;
    // console.log(ardb_data);
  }
  res.render("admin/calendar_edit", {
    cal_data: calDt,
    heading: "Calendar",
    sub_heading: "Event List Edit",
    dateFormat,
  });
});

adminRouter.post("/calendar_edit", async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss"),
    user = req.session.user.USER_NAME,
    id = data.sl_no;
  var pax_id = db_id,
    table_name = "TD_CALENDAR",
    fields =
      id > 0
        ? "CAL_DT = :0, CAL_EVENT = :1, MODIFIED_BY = :2, MODIFIED_DT = :3"
        : "SL_NO, CAL_DT, CAL_EVENT, CREATED_BY, CREATED_DT",
    fieldIndex = `((SELECT Decode(MAX(SL_NO),1,MAX(SL_NO),0)+1 FROM TD_CALENDAR), :0, :1, :2, :3)`,
    values = [
      dateFormat(data.cal_dt, "dd-mmm-yy"),
      data.cal_event,
      user,
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = id > 0 ? `SL_NO = ${id}` : null,
    flag = id > 0 ? 1 : 0;
  var resDt = await Api_Insert(
    pax_id,
    table_name,
    fields,
    fieldIndex,
    values,
    where,
    flag
  );
  if (resDt.suc > 0) {
    req.session.message = {
      type: "success",
      message: "Successfully Saved",
    };
    res.redirect("/admin/calendar");
    // res_dt = { suc: 1, msg: resDt.msg };
  } else {
    // res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
    req.session.message = {
      type: "danger",
      message: "Data Not Inserted!!",
    };
    res.redirect("/admin/calendar_edit?id=" + id);
  }
});

adminRouter.get('/calendar_del', async (req, res) => {
  var id = req.query.id,
  user = req.session.user;
  console.log(id);
  var resDt = await F_Delete(user.BANK_ID, 'TD_CALENDAR', `SL_NO = '${id}'`);
  if (resDt.suc > 0) {
    req.session.message = {
      type: "success",
      message: "Successfully Deleted",
    };
    res.redirect("/admin/calendar");
  //   // res_dt = { suc: 1, msg: resDt.msg };
  } else {
    // res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
    req.session.message = {
      type: "danger",
      message: "Please try again later!!",
    };
    res.redirect("/admin/calendar");
  }
})

adminRouter.get("/notification", async (req, res) => {
  var pax_id = db_id,
    fields = "user_cd, user_name, cust_cd",
    table_name = "md_user",
    where = `user_type != 'A'`,
    order = null,
    flag = 1;
  var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
  // console.log(res_dt);
  res.render("notification/entry", {
    heading: "Send Notification",
    emp_list: resDt.suc > 0 ? resDt.msg : null,
  });
});

adminRouter.post("/notification", async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss"),
    user = req.session.user.USER_NAME, resDt = {}, bank_id = req.session.user.BANK_ID;
  if(data.user_id != 'all' && data.user_id != ''){
    var pax_id = bank_id,
      table_name = "TD_NOTIFICATION",
      fields = "SL_NO, NARRATION, SEND_USER_ID, CREATED_BY, CREATED_DT",
      fieldIndex = `((SELECT Nvl(MAX(SL_NO),0)+1 FROM TD_NOTIFICATION), :0, :1, :2, :3)`,
      values = [
        data.narration,
        data.user_id,
        user,
        dateFormat(datetime, "dd-mmm-yy"),
      ],
      where = null,
      flag = 0;
    resDt = await Api_Insert(
      pax_id,
      table_name,
      fields,
      fieldIndex,
      values,
      where,
      flag
    );
  }

  if(data.user_id == 'all'){
    var pax_id = bank_id,
    fields = "user_cd, user_name, cust_cd",
    table_name = "md_user",
    where = `user_type != 'A' AND bank_id = ${bank_id}`,
    order = null,
    flag = 1;
    var userDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    if(userDt.suc > 0 && userDt.msg.length > 0){
      for(let udt of userDt.msg){
        var table_name = "TD_NOTIFICATION",
          fields = "SL_NO, NARRATION, SEND_USER_ID, CREATED_BY, CREATED_DT",
          fieldIndex = `((SELECT Nvl(MAX(SL_NO),0)+1 FROM TD_NOTIFICATION), :0, :1, :2, :3)`,
          values = [
            data.narration,
            udt.USER_CD,
            user,
            dateFormat(datetime, "dd-mmm-yy"),
          ],
          where = null,
          flag = 0;
        resDt = await Api_Insert(
          pax_id,
          table_name,
          fields,
          fieldIndex,
          values,
          where,
          flag
        );
      }
    }
  }
  // console.log(resDt.suc);
  if (resDt.suc > 0) {
    var ioDt = await SendNotification({bank_id: bank_id});
    req.io.emit('notification', ioDt);
    req.session.message = {
      type: "success",
      message: "Notification Sent Successfully",
    };
    res.redirect("/admin/notification");
    // res_dt = { suc: 1, msg: resDt.msg };
  } else {
    // res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
    req.session.message = {
      type: "danger",
      message: "Notification Not Sent",
    };
    res.redirect("/admin/notification");
  }
});

adminRouter.get('/reset_mpin', async (req, res) => {
  res.render("reset_mpin/reset", {
    heading: "Reset mPIN",
  });
})

adminRouter.post('/reset_mpin', async (req, res) => {
  var data = req.body;
  var phone_no = data.user_id,
    remarks = data.remarks;
  var otp = Math.floor(1000 + Math.random() * 9000);
  var text = `Dear User, ${otp} is your Bikash verification code. Do not share it with anyone.-SYNERGIC`;
  console.log(text);
  // return new Promise((resolve, reject) => {
  var chk_user = await chkUser(phone_no);
  if (chk_user.suc > 0) {
    var options = {
      'method': 'GET',
      'url': 'https://bulksms.sssplsales.in/api/api_http.php?username=SYNERGIC&password=SYN@526RGC&senderid=SYNRGC&to=' + phone_no + '&text=' + text + '&route=Informative&type=text',
      'headers': {
      }
    };
    request(options, async (error, response) => {
      if (error) {
        // throw new Error(error);
        // console.log(err);
        // res.send({suc:0, msg: 'Otp Not Sent', otp})
        req.session.message = {
          type: "danger",
          message: "Otp Not Sent",
        };
        res.redirect("/admin/reset_mpin");
      }
      else {
        var resdt = await resetMpin(phone_no, otp, remarks);
        console.log(resdt);
        if(resdt.suc > 0){
          req.session.message = {
            type: "success",
            message: "mPIN updated successfully",
          };
          res.redirect("/admin/reset_mpin");
        }else{
          req.session.message = {
            type: "danger",
            message: "mPIN not updated successfully",
          };
          res.redirect("/admin/reset_mpin");
        }
        // res.send({ suc: 1, msg: 'Otp Sent', otp })
        // console.log(response.body);
      }
      // resolve(true);
    });
  } else {
    req.session.message = {
      type: "danger",
      message: "User Doesnot Exist",
    };
    res.redirect("/admin/reset_mpin");
  }
})

const resetMpin = (phone_no, pin, remarks) => {
  var pass = bcrypt.hashSync(pin.toString(), 10);
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");

  return new Promise(async (resolve, reject) => {
    var res_dt;
    var pax_id = db_id,
      table_name = "MD_USER",
      fields = `MPIN = :0, RESET_REMARKS = :1, MODIFIED_BY = :2, MODIFIED_DT = :3`,
      fieldIndex = null,
      values = [pass, remarks, phone_no.split(' ').join(''), dateFormat(datetime, "dd-mmm-yy")],
      where = `USER_CD = '${phone_no.split(' ').join('')}'`,
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
    resolve(res_dt)
  })
}

  adminRouter.get('/change_pass', async (req, res) => {
    console.log(req.session.user.USER_CD);
    var id = req.session.user.USER_CD;
    var bank_id = req.session.user.BANK_ID;
    res.render("user/change_pass", {
      heading: "Reset mPIN",id:id
    });
  })

  adminRouter.post("/change_pass", async (req, res) => {
   var data = req.body;
   var pin = data.pass,
     oldPin = data.old_pass;
   var phone_no = req.session.user.USER_CD
   //const salt = bcrypt.genSaltSync(10); 
   var pass = bcrypt.hashSync(pin, 10);
   // Adjust rounds if needed
   // const hashedPassword = bcrypt.hashSync(password, salt);
   var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");

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
       req.session.message = {
        type: "success",
        message: "Successfully Updated",
      };
      res.redirect("/admin/change_pass");
     } else {
       res_dt = { suc: 0, msg: "Please Enter Your Correct old mPIN" };
       req.session.message = {
        type: "danger",
        message: "Please Enter Your Correct old mPIN",
      };
      res.redirect("/admin/change_pass");
     }
   } else {
    req.session.message = {
      type: "danger",
      message: "User Not Found",
    };
     res.redirect("/admin/change_pass");
   }
 })
  

const getReqList = (id) => {
  return new Promise(async (resolve, reject) => {
    var pax_id = db_id,
      fields = "a.sl_no, a.req_dt, a.req_cust_id, a.acc_type_id, a.acc_type_name, a.acc_no, a.req_flag, a.frm_dt, a.to_dt, a.update_flag, a.remarks, b.FIRST_NAME, b.EMAIL, b.PHONE",
      table_name = "td_request a, MM_CUSTOMER b",
      where = id > 0 ? `a.REQ_CUST_ID = b.CUST_CD AND sl_no =${id}` : "a.REQ_CUST_ID = b.CUST_CD",
      order = null,
      flag = id > 0 ? 0 : 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    resolve(resDt);
  });
};


adminRouter.get('/request', async (req, res) => {
  var id = null;
  var resDt = await getReqList(id);
  // console.log(resDt);
  // if (resDt.suc > 0) {
  res.render("request/view", {
    req_dt: resDt,
    heading: "Request",
    sub_heading: "Request List",
    dateFormat,
  });
})

adminRouter.get('/request_edit', async (req, res) => {
  var id = req.query.id > 0 ? req.query.id : null;
  var reqDt = null;
  if (id > 0) {
    var res_dt = await getReqList(id);
    reqDt = res_dt.suc > 0 ? res_dt.msg : null;
    // console.log(ardb_data);
  }
  res.render("request/edit", {
    req_data: reqDt,
    heading: "Request",
    sub_heading: "Request Edit",
    dateFormat,
  });
})

adminRouter.post("/request_edit", async (req, res) => {
  var data = req.body;
  var datetime = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss"),
    user = req.session.user.USER_NAME,
    id = data.sl_no;
  var pax_id = db_id,
    table_name = "TD_REQUEST",
    fields = "UPDATE_FLAG = :0, REMARKS = :1, UPDATED_BY = :2, UPDATED_AT = :3",
    fieldIndex = null,
    values = [
      data.update_flag,
      data.remarks,
      user,
      dateFormat(datetime, "dd-mmm-yy"),
    ],
    where = `SL_NO = ${id}`,
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
  if (resDt.suc > 0) {
    req.session.message = {
      type: "success",
      message: "Successfully Updated",
    };
    res.redirect("/admin/request");
    // res_dt = { suc: 1, msg: resDt.msg };
  } else {
    // res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
    req.session.message = {
      type: "danger",
      message: "Data Not Inserted!!",
    };
    res.redirect("/admin/request_edit?id=" + id);
  }
});

adminRouter.get('/logout', async (req, res) => {
  var user = req.session.user
  req.session.destroy(() => {
    res.redirect('/admin/login');
  });
})

const getFeedBack = (id) => {
  return new Promise(async (resolve, reject) => {
    var pax_id = db_id,
      fields = "sl_no, rating, remarks, created_by, created_at",
      table_name = "td_feedback",
      where = id > 0 ? `sl_no =${id}` : "",
      order = null,
      flag = id > 0 ? 0 : 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    resolve(resDt);
  });
}

adminRouter.get('/feedback', async (req, res) => {
  var id = null;
  var resDt = await getFeedBack(id);
  // console.log(resDt);
  // if (resDt.suc > 0) {
  res.render("feedback/view", {
    req_dt: resDt,
    heading: "Feedback",
    sub_heading: "Feedback List",
    dateFormat,
  });
})

const AllUserList = (id) => {
  return new Promise(async (resolve, reject) => {
    var pax_id = db_id,
      fields = "user_cd, cust_cd, last_login, user_name, active_status",
      table_name = "md_user",
      where = id > 0 ? `user_cd =${id}` : "user_type != 'A'",
      order = null,
      flag = id > 0 ? 0 : 1;
    var resDt = await F_Select(pax_id, fields, table_name, where, order, flag);
    resolve(resDt);
  });
}

adminRouter.get('/user_list', async (req, res) => {
  var id = null;
  var resDt = await AllUserList(id);
  res.render("user/user_list", {
    req_dt: resDt,
    heading: "Registered User List",
    sub_heading: "User List",
    dateFormat,
  });
})

adminRouter.get('/user_delete', async (req, res) => {
  var id = req.query.id;
  console.log(id);
  var resDt = await F_Delete(db_id, 'md_user', `user_cd = '${id}'`);
  if (resDt.suc > 0) {
    req.session.message = {
      type: "success",
      message: "Successfully Deleted",
    };
    res.redirect("/admin/user_list");
  //   // res_dt = { suc: 1, msg: resDt.msg };
  } else {
    // res_dt = { suc: 0, msg: "You have entered a wrong PIN" };
    req.session.message = {
      type: "danger",
      message: "Please try again later!!",
    };
    res.redirect("/admin/user_list");
  }
})

adminRouter.get('/privacy', (req, res) => {
  res.render('admin/privecy')
})

module.exports = { adminRouter };
