package com.qsy.workbench.controller;

import com.qsy.workbench.pojo.Activity;
import com.qsy.workbench.pojo.ActivityRemark;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.settings.pojo.User;
import com.qsy.workbench.service.ActivityRemarkService;
import com.qsy.workbench.service.ActivityService;
import com.qsy.settings.service.UserService;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.HSSFUtils;
import com.qsy.utils.IDUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

/**
 * @author qsy
 * @create 2022/3/31 - 10:28
 */
@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;
    @RequestMapping("/workbench/activity/index.do")
    public String index(Model model){
        //调用Service层方法，查询所有用户
        List<User> userList = userService.queryAllUser();
        //把数据保存在model中
        model.addAttribute("userList",userList);
        //请求返回到市场活动主页面
        return "workbench/activity/index";
    }

    @RequestMapping("workbench/activity/addActivity.do")
    @ResponseBody
    public Object addActivity(Activity activity, HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setId(IDUtils.getId());
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        //调用Service层方法，保存创建的市场活动
        try {
            int result = activityService.addActivity(activity);
            if(result>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后在来");
        }
        return returnInfoObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,
                                                                int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service层方法，查询数据
        List<Activity> activityList=activityService.queryActivityByConditionForPage(map);
        int totalRows=activityService.queryCountOfActivityByCondition(map);
        //根据查询结果结果，生成响应信息
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] ids){
        System.out.println(ids);
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = activityService.deleteActivityById(ids);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;

    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        //调用service层方法，查询市场活动
        Activity activity=activityService.queryActivityById(id);
        //根据查询结果，返回响应信息
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivityById.do")
    @ResponseBody
    public Object saveEditActivityById(Activity activity,HttpSession session){
        //封装数据
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            //调用service层方法，保存修改的活动信息
            int ret = activityService.saveEditActivityById(activity);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else {
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试");
        }
        return returnInfoObject;
    }

    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws Exception {
        //读服务器上的一个excel文件往回返
        //1、设置response响应类型
        //application/octet-stream;charset=UTF-8  excel文件  二进制文件
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.获取输出流
        OutputStream out = response.getOutputStream();

        //浏览器接收到响应信息后，默认情况下，会在显示窗口中打开响应信息，
        // 即使打不开也会调用电脑上的应用程序来打开，只有实在打不开才会激活文件下载

        //设置响应头信息，使浏览器接收到响应信息后，直接激活文件下载窗口，即使能打开也不打开
        //Content-Disposition 内容布置安排、设置打开方式，
        // attachment 附件方式打开——下载
        // filename=设置下载的文件名
        response.addHeader("Content-Disposition","attachment;filename=myStudentList.xls");

        //3.首先读取磁盘上的文件(inputStream)，然后把文件输出到浏览器(outputStream)
        InputStream in = new FileInputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\studentList.xls");
        //read()方法一个字节一个字节的读取，效率太低，因此建立一个缓冲区，以缓冲区为单位读取
        //依据文件大小来设置缓冲区
        byte[] buffer = new byte[256];
        int len=0;
        //in.read(buffer)返回值int，表示每次读几个字节
        //读到返回值是-1就读完一个缓冲区
        while((len=in.read(buffer))!=-1){
            //缓冲区可能没读完，所以从第0个元素开始写，读几个写几个
            out.write(buffer,0,len);
        }

        //关闭资源原则，谁开启谁关闭
        in.close();
        //将缓冲区数据全部刷到输出端
        out.flush();
    }

    //列表导出为文件/批量文件下载
    @RequestMapping("/workbench/activity/exportQueryAllActivity.do")
    public void exportQueryAllActivity(HttpServletResponse response) throws Exception{
        //调用service层方法，查询所以活动信息
        List<Activity> activityList = activityService.queryAllActivity();
        //创建excel文件，并把activityList放入excel
        //horrible spreadsheet format 讨厌的电子表格
        HSSFWorkbook workbook= new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("活动ID");
        cell=row.createCell(1);
        cell.setCellValue("活动所有者");
        cell=row.createCell(2);
        cell.setCellValue("活动名称");
        cell=row.createCell(3);
        cell.setCellValue("开始时间");
        cell=row.createCell(4);
        cell.setCellValue("结束时间");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");

//        遍历list，获取row对象，生成所有的数据行
        if(activityList!=null&&activityList.size()>0){
            Activity activity=null;
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);

                //没边了出一个activity,生成一行
                row=sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell=row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell=row.createCell(2);
                cell.setCellValue(activity.getName());
                cell=row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell=row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell=row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell=row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell=row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell=row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell=row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell=row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        //根据workbook对象生成excel文件
        //1、将内存中数据写到磁盘文件
//        OutputStream outputStream = new FileOutputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\activityList.xls");
//        //效率很低 底层方法复杂，访问磁盘，
//
//        workbook.write(outputStream);


        //关闭资源
//        outputStream.close();
//        workbook.close();


        //把生成的excel文件下载到客户端
        //1.设置响应信息
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.设置响应头
        response.addHeader("Content-Disposition","attachment;filename=myActivityList.xls");

        //3.设置输出流
        OutputStream out = response.getOutputStream();
        //4.读取磁盘上的文件到内存，然后把文件写到客户端（输出流里——连着浏览器）
//        InputStream in = new FileInputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\activityList.xls");
//        byte[] buffer = new byte[256];
//
//        int len=0;
        //2、将磁盘中文件读到内存
//        //循环效率低，因为要去磁盘读数据，读也要建立连接，找磁道
//        while((len=in.read(buffer))!=-1){
//            out.write(buffer,0,len);
////        }
//
//        //关闭资源
//        in.close();

        //文件下载优化，实现内存到内存，
        // 将内存中workbook中数据直接放到与浏览器建立连接的输出流里
        workbook.write(out);

        workbook.close();
        //将流里的数据强制冲刷出去
        out.flush();


    }

    @RequestMapping("workbench/activity/fileUpload.do")
   //请求是提交form表单的同步请求，因此方法需要返回网页，成功返回成功网页，失败放回失败网页，
//    需要再写两个jsp网页，
//    若在同步请求情况下，使用返回json字符串的方法，前台浏览器无法解析返回信息
    public @ResponseBody Object fileUpload(String userName, MultipartFile myFile) throws Exception{
        //把文本数据打印到控制台
        System.out.println("userName="+userName);
        //把文件在服务指定的目录中生成一个同样的文件
        String originalFilename=myFile.getOriginalFilename();
        File file=new File("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\",originalFilename);//路径必须手动创建好，文件如果不存在，会自动创建
        myFile.transferTo(file);

        //返回响应信息
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        returnInfoObject.setMessage("上传成功");
        return returnInfoObject;
    }


    //导入市场活动
    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,HttpSession session,String username){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        //把接收到的文件写到磁盘目录上
        File file= null;//路径必须手动创建好，文件如果不存在，会自动创建
        try {
//            String originalFilename = activityFile.getOriginalFilename();
//             file = new File("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\",originalFilename);
             //执行前文件存储在activityFile对象中，执行后将文件转移到磁盘中
//            activityFile.transferTo(file);

            //获得一个输入流连接activityFile对象
            InputStream in = activityFile.getInputStream();
            //解析excel文件,获取文件中的数据并且封装成activityList
//            InputStream in = new FileInputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\"+originalFilename);
            HSSFWorkbook workbook = new HSSFWorkbook(in);
            HSSFSheet sheet = workbook.getSheetAt(0);
            HSSFRow row = null;
            HSSFCell cell =null;
            Activity activity=null;
            List<Activity> activityList = new ArrayList<>();
            for (int i = 1; i <=sheet.getLastRowNum(); i++) {
                row=sheet.getRow(i);
                activity=new Activity();
                activity.setId(IDUtils.getId());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    cell=row.getCell(j);

                    //获取列中数据
                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    switch (j){
                        case 0:
                            activity.setName(cellValue);
                            break;
                        case 1:
                            activity.setStartDate(cellValue);
                            break;
                        case 2:
                            activity.setEndDate(cellValue);
                            break;
                        case 3:
                            activity.setCost(cellValue);
                            break;
                        case 4:
                            activity.setDescription(cellValue);
                            break;
                        default:
                            break;
                    }
                }
                //每一行中所有列都封装完成后，把activity保存到List中
                activityList.add(activity);
            }

            //调用service层方法，保存市场活动
            int ret = activityService.addActivityByList(activityList);
            //当文件没有数据行，数据行为空时，也不会报错 因此前台显示返回信息即可

            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnInfoObject.setReturnData(ret);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }

    //查询活动明细
    @RequestMapping("/workbench/activity/queryActivityDetail.do")
    public String  ActivityDetail(String id,Model model){
        //调用service层方法，查询活动信息和备注信息
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        //将数据封装到model里
        model.addAttribute("activity",activity);
        model.addAttribute("remarkList",remarkList);

        return "workbench/activity/detail";
    }


}
