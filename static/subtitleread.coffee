root = exports ? this
print = console.log

class SubtitleRead
  constructor: (subtitleText) ->
    @subtitleText = subtitleText
    timeToSubtitle = {}
    timesAndSubtitles = [] # start,end,subtitle
    awaitingTime = true
    startTime = 0.0
    endTime = 0.0
    lineContents = ''
    for line in subtitleText.split('\n')
      line = line.trim()
      if line == ''
        if lineContents != ''
          timesAndSubtitles.push([startTime,endTime,lineContents])
        awaitingTime = true
        lineContents = ''
      else if awaitingTime
        if line.indexOf(' --> ') != -1
          awaitingTime = false
          [startTime, endTime] = line.split(' --> ')
          toDeciSeconds = (time) ->
            time = time.replace(',', '.')
            [hour,min,sec] = time.split(':')
            hour = parseInt(hour)
            min = parseInt(min)
            sec = parseFloat(sec)
            return Math.round((hour*3600 + min*60 + sec)*10)
          startTime = toDeciSeconds(startTime)
          endTime = toDeciSeconds(endTime)
          awaitingTime = false
      else
        lineContents = (lineContents + ' ' + line).trim()
    
    for triplet in timesAndSubtitles
      [startTime,endTime,lineContents] = triplet
      while startTime < endTime + 50
        timeToSubtitle[startTime] = lineContents
        ++startTime
    @timeToSubtitle = timeToSubtitle
    @timesAndSubtitles = timesAndSubtitles

  subtitleAtTime: (deciSec) ->
    retv = this.timeToSubtitle[deciSec]
    if retv
      retv
    else
      ''

root.SubtitleRead = SubtitleRead

