function shuangxianxingchazhi, chazhiduixiang,lon,lat,aftlon,aftlat,chuzhilon,chuzhilat,LONAFT=lonaft,LATAFT=lataft,showlat=showlat,showlon=showlon
;插值对象（chazhiduixiang），输入插值前的经纬度（lon,lat），插值后的经纬格点数（aftlon,aftlat），插值起点（chuzhilon,chuzhilat）
;插值后的经纬度（lonaft,lataft）
;,/showlat和,/showlon用来临时输出插值后的经纬度以调整起点找到满意的插值
;插值不成功时，注意检查插值步长。
dims=size(chazhiduixiang)
print,dims
beflon=dims(1)*1.0
beflat=dims(2)*1.0
magnifylat=beflat/aftlat
magnifylon=beflon/aftlon
  ;--------双线性插值，(720,360)到(360,180)，格点间隔从0.5到0.1，初始值需要尝试--------
  lat1=FLTARR(beflat,2) & lat2=FLTARR(aftlat,2)
  FOR i = 0,beflat-1 DO BEGIN
    lat1(i,*)=lat(i)
  ENDFOR

  ix=FLTARR(beflon) & jy=FLTARR(aftlat)
  ix(0) = 0.0
  ix(INDGEN(beflon)+1) = INDGEN(beflon)
  jy(0) =chuzhilat & jy(INDGEN(aftlat-1)+1) = INDGEN(aftlat-1)*magnifylat + magnifylat+chuzhilat

  lat2=BILINEAR(lat1,jy,ix,MISSING=!VALUES.F_NAN)
  help,lat2
  if(abs(lat2[0]) gt abs(lat[0]) or abs(lat2[aftlat-1]) gt abs(lat[beflat-1]))then begin
    print,'插值后的纬度溢出原纬度的边界,重新选择插值起点或插值间隔'
    stop
  endif
  
  if(keyword_set(showlat))then begin
  print,lat2(*,0)
  endif
  lataft=fltarr(aftlat)
  lonaft=fltarr(aftlon)





  lon1=FLTARR(beflon,2) & lon2=FLTARR(aftlon,2)
  FOR i = 0,beflon-1 DO BEGIN
    lon1(i,*)=lon(i)
  ENDFOR

  ix=FLTARR(aftlon) & jy=FLTARR(beflat)
  jy(0) = 0.0
  jy(INDGEN(beflat)+1) = INDGEN(beflat)
  ix(0) =chuzhilon & ix(INDGEN(aftlon-1)+1) = INDGEN(aftlon-1)*magnifylon + magnifylon+chuzhilon

  lon2=BILINEAR(lon1,ix,jy,MISSING=!VALUES.F_NAN)
  if(abs(lon2[0]) gt abs(lon[0]) or abs(lon2[aftlon-1]) gt abs(lon[beflon-1]))then begin
    print,'插值后的经度溢出原经度的边界,重新选择插值起点或插值间隔'
    stop
  endif
  
  if(keyword_set(showlon))then begin
  print,lon2(*,0)
  endif
  lataft=lat2(*,0)
  lonaft=lon2(*,0)


  ix=FLTARR(aftlon) & jy=FLTARR(aftlat)
  ix(0) =chuzhilon & ix(INDGEN(aftlon-1)+1) = INDGEN(aftlon-1)*magnifylon + magnifylon+chuzhilon
  jy(0) =chuzhilat & jy(INDGEN(aftlat-1)+1) = INDGEN(aftlat-1)*magnifylat + magnifylat+chuzhilat

  chazhiduixiang2=BILINEAR(chazhiduixiang(*,*,0),ix,jy,MISSING=!VALUES.F_NAN)
  
  return,chazhiduixiang2
  end