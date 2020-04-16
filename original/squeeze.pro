function squeeze,origarr
;用于删除长度为1的数组，参见matlab中的squeeze
dims=size(origarr)

if(dims[0] eq 2.)then begin
  new=fltarr(dims[2])
  for i=0,dims[2]-1 do begin
  new[i]=origarr[0,i]
  endfor
endif

if(dims[0] eq 3.)then begin
  new=fltarr(dims[3])
  for i=0,dims[3]-1 do begin
  new[i]=origarr[0,0,i]
  endfor
endif

if(dims[0] eq 4.)then begin
  new=fltarr(dims[4])
  for i=0,dims[4]-1 do begin
  new[i]=origarr[0,0,0,i]
  endfor
endif


return,new
end
