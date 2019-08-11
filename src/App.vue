<template>
  <div id="app">
    <section class="main" :style="{backgroundColor: getColor.color, color: getColor.text}">
      <section class="content">
        <ul class="color-list">
          <li
            v-for="(item, index) in colorList"
            :key="index"
            :style="{borderColor: item.color}"
            @click="handleClick(index)"
          >{{item.label}}</li>
        </ul>
      </section>
      <div class="broad">
        <h1>{{getColor.label}}</h1>
        <h3>{{getColor.jp}}</h3>
        <h2 @click="handleCopy(getColor.color)">{{getColor.color}}</h2>
        <h2 @click="handleCopy(`rgb(${getColor.rgb})`)">RGB: {{getColor.rgb}}</h2>
      </div>
      <transition name="fade">
        <span class="tips" v-if="isShowTip">已复制</span>
      </transition>
      <textarea id="input"></textarea>
    </section>
  </div>
</template>
<script>
import color from "@/assets/color";
import { setTimeout } from "timers";

function randomNum(minNum, maxNum) {
  // 生成随机数
  switch (arguments.length) {
    case 1:
      return parseInt(Math.random() * minNum + 1, 10);
      break;
    case 2:
      return parseInt(Math.random() * (maxNum - minNum + 1) + minNum, 10);
      break;
    default:
      return 0;
      break;
  }
}
const countColor = value => {
  var _value = "0x" + value.replace(/#/g, "");
  var str = "000000" + (0xffffff - _value).toString(16);
  return `#${str.substring(str.length - 6, str.length)}`;
  // return Number(_value) > 888888 ? '#333' : '#fff'
};

const countRgb = value => {
  var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
  // 如果是16进制颜色
  if (value && reg.test(value)) {
    if (value.length === 4) {
      var valueNew = "#";
      for (var i = 1; i < 4; i += 1) {
        valueNew += value.slice(i, i + 1).concat(value.slice(i, i + 1));
      }
      value = valueNew;
    }
    //处理六位的颜色值
    var valueChange = [];
    for (var i = 1; i < 7; i += 2) {
      valueChange.push(parseInt("0x" + value.slice(i, i + 2)));
    }
    return valueChange.join(",");
  }
  return value;
};

export default {
  data: () => ({ colorList: [], activeIndex: 0, isShowTip: false }),
  beforeMount() {
    this.colorList = color;
    this.activeIndex = randomNum(0, color.length - 1);
  },
  methods: {
    handleClick(index) {
      this.activeIndex = index;
    },
    handleCopy(color) {
      var input = document.getElementById("input");
      input.value = color; // 修改文本框的内容
      input.select(); // 选中文本
      document.execCommand("copy"); // 执行浏览器复制命令
      this.isShowTip = true;
      setTimeout(() => {
        this.isShowTip = false;
      }, 1000);
    }
  },
  computed: {
    getColor() {
      const { label, jp, color } = this.colorList[this.activeIndex];
      return {
        label,
        color,
        jp,
        text: countColor(color),
        rgb: countRgb(color)
      };
    }
  }
};
</script>


<style lang="less">
html,
body {
  height: 100%;
}
* {
  padding: 0;
  margin: 0;
  list-style: none;
}
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  height: 100%;
}
.main {
  height: 100%;
  width: 100%;
  background-image: url("./assets/texture.png");
  transition: 1s all ease;
  overflow: auto;
  position: relative;
  display: flex;
  justify-content: center;
  .content {
    max-width: 1200px;
  }
  .color-list {
    min-width: 500px;
    max-width: 800px;
    display: flex;
    flex-wrap: wrap;
    li {
      width: 80px;
      height: 40px;
      display: flex;
      align-items: center;
      margin: 10px 20px;
      padding-left: 18px;
      text-align: left;
      cursor: pointer;
      border-left: 8px solid;
    }
  }
  .broad {
    position: fixed;
    text-align: right;
    font-weight: 100;
    left: calc(50vw + 400px);
    top: 50px;
    width: 200px;
    h1 {
      width: 1em;
      font-weight: normal;
      user-select: none;
      font-size: 50px;
    }
    h2 {
      font-weight: 100;
      user-select: none;
      cursor: pointer;
    }
  }
  .tips {
    width: 80px;
    height: 35px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    left: calc(50vw + 600px - 80px);
    top: 64px;
    background: rgba(255, 255, 255, 0.5);
    border-radius: 4px;
    color: #2c3e50;
    box-shadow: 0 0 8px rgba(255, 255, 255, 0.8);
  }
  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.5s;
  }
  .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
    opacity: 0;
  }
  #input {
    position: absolute;
    top: 0;
    left: 0;
    opacity: 0;
    z-index: -10;
  }
}
</style>
